package com.admetus.solum

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.RequiresPermission
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.admetus.solum.ui.theme.BegeClaro
import com.admetus.solum.ui.theme.SolumTheme
import com.admetus.solum.ui.theme.VerdeEscuro
import java.io.IOException
import java.util.UUID

var bluetoothSocket: BluetoothSocket? = null
val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
val deviceAddress = "00:19:10:09:32:B1"
val MY_UUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

class MainActivity : ComponentActivity() {

    private val requestBluetoothConnectPermission = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        if (granted) {
            connectBluetooth()
        } else {
            connectionStatus.value = "Permissão negada"
        }
    }

    companion object {
        var connectionStatus = mutableStateOf("Desconectado")
        var isConnected = mutableStateOf(false)
        var sistemaLigado = mutableStateOf(false)
        var pilotoAutomatico = mutableStateOf(false)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            SolumTheme {
                ControleSolumApp()
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            requestBluetoothConnectPermission.launch(Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            checkBluetoothAndConnect()
        }
    }

    @RequiresPermission(Manifest.permission.BLUETOOTH_CONNECT)
    private fun checkBluetoothAndConnect() {
        if (bluetoothAdapter == null) {
            connectionStatus.value = "Bluetooth não suportado"
            return
        }

        if (!bluetoothAdapter.isEnabled) {
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            startActivity(enableBtIntent)
        }

        connectBluetooth()
    }

    private fun connectBluetooth() {
        connectionStatus.value = "Conectando..."
        isConnected.value = false

        Thread {
            val device: BluetoothDevice? = bluetoothAdapter?.getRemoteDevice(deviceAddress)
            try {
                bluetoothSocket = device?.createRfcommSocketToServiceRecord(MY_UUID)
                bluetoothSocket?.connect()
                connectionStatus.value = "Conectado!"
                isConnected.value = true
            } catch (e: IOException) {
                e.printStackTrace()
                connectionStatus.value = "Erro ao conectar"
                isConnected.value = false
                bluetoothSocket = null
            }
        }.start()
    }
}

@Composable
fun ControleSolumApp() {
    val sistemaLigado = MainActivity.sistemaLigado
    val pilotoAutomatico = MainActivity.pilotoAutomatico
    val isConnected = MainActivity.isConnected

    Row(
        modifier = Modifier
            .fillMaxSize()
            .padding(30.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {

        // =========================
        // CONTROLE MANUAL
        // =========================
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Button(
                onClick = { enviarComando("F") },
                enabled = isConnected.value && sistemaLigado.value && !pilotoAutomatico.value,
                colors = ButtonDefaults.buttonColors(
                    containerColor = VerdeEscuro,
                    contentColor = BegeClaro
                )
            ) { Icon(Icons.Filled.ArrowUpward, contentDescription = "Frente") }

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                horizontalArrangement = Arrangement.spacedBy(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Button(
                    onClick = { enviarComando("E") },
                    enabled = isConnected.value && sistemaLigado.value && !pilotoAutomatico.value,
                    colors = ButtonDefaults.buttonColors(
                        containerColor = VerdeEscuro,
                        contentColor = BegeClaro
                    )
                ) { Icon(Icons.Filled.ArrowBack, contentDescription = "Esquerda") }

                Button(
                    onClick = { enviarComando("R") },
                    enabled = isConnected.value && sistemaLigado.value && !pilotoAutomatico.value,
                    colors = ButtonDefaults.buttonColors(
                        containerColor = VerdeEscuro,
                        contentColor = BegeClaro
                    )
                ) { Icon(Icons.Filled.ArrowForward, contentDescription = "Direita") }
            }

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = { enviarComando("B") },
                enabled = isConnected.value && sistemaLigado.value && !pilotoAutomatico.value,
                colors = ButtonDefaults.buttonColors(
                    containerColor = VerdeEscuro,
                    contentColor = BegeClaro
                )
            ) { Icon(Icons.Filled.ArrowDownward, contentDescription = "Trás") }
        }

        // =========================
        // STATUS
        // =========================
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color(0xFFE0E0E0)),
            modifier = Modifier.padding(horizontal = 16.dp)
        ) {
            Text(
                text = MainActivity.connectionStatus.value,
                modifier = Modifier.padding(16.dp),
                style = MaterialTheme.typography.bodyLarge
            )
        }

        // =========================
        // LIGAR E PILOTO AUTOMÁTICO
        // =========================
        Row(horizontalArrangement = Arrangement.spacedBy(16.dp), verticalAlignment = Alignment.CenterVertically) {
            Button(
                onClick = {
                    if (sistemaLigado.value) {
                        enviarComando("D")
                        sistemaLigado.value = false
                        pilotoAutomatico.value = false
                    } else {
                        enviarComando("L")
                        sistemaLigado.value = true
                    }
                },
                modifier = Modifier.size(80.dp),
                shape = CircleShape,
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (sistemaLigado.value) Color(0XFF2E7D32) else Color(0XFFC62828),
                    contentColor = Color.White
                )
            ) {
                Icon(Icons.Filled.PowerSettingsNew, contentDescription = if (sistemaLigado.value) "Desligar" else "Ligar", modifier = Modifier.size(32.dp))
            }

            Button(
                onClick = {
                    if (sistemaLigado.value) {
                        pilotoAutomatico.value = !pilotoAutomatico.value
                        enviarComando(if (pilotoAutomatico.value) "A" else "O")
                    }
                },
                modifier = Modifier.size(80.dp),
                enabled = sistemaLigado.value,
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (pilotoAutomatico.value) Color(0xFF2E7D32) else Color(0xFFC62828),
                    contentColor = Color.White
                ),
                shape = CircleShape
            ) {
                Icon(Icons.Filled.Person, contentDescription = "Piloto Automático", modifier = Modifier.size(40.dp))
            }
        }
    }
}

// Função para enviar comandos
fun enviarComando(comando: String) {
    Thread {
        try {
            bluetoothSocket?.outputStream?.write((comando + "\n").toByteArray())
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }.start()
}

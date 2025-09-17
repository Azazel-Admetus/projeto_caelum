package com.admetus.solum.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color


private val LightColorScheme = lightColorScheme(
    primary = VerdeEscuro,
    secondary = VerdeOliva,
    background = BegeClaro,
    surface = Bege,
    onPrimary = Color.White,
    onSecondary = Color.White,
    onBackground = VerdeEscuro,
    onSurface = VerdeEscuro
)

@Composable
fun SolumTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        typography = Typography,
        content = content
    )
}
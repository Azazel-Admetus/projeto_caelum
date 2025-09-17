package com.admetus.solum.ui.theme //aqui definimos a qual pacote este arquivo pertence

import androidx.compose.material3.Typography //aqui importamos algumas funções para ter uso prático
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import com.admetus.solum.R
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

// vamos criar a variável para a fonte principal

val MinhaFonte = FontFamily(
    Font(R.font.fonte_main)
)
val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = MinhaFonte,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)

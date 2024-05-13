package com.doinglab.foodlens.sample.listview

import android.graphics.drawable.Drawable

data class RecognitionItem (
    val name : String? = null,
    val icon : Drawable? = null,
    val foodPosition: String? = null,
    val foodNutrition: String? = null,
    val energy:String? = null,
)
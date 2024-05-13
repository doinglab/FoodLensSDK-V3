package com.doinglab.foodlens.sample.util

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import java.io.File
import java.io.FileInputStream

object BitmapUtil {

    fun getBitmapFromFile(filePath: String): Bitmap? {
        val options = BitmapFactory.Options()
        return BitmapFactory.decodeFile(filePath, options)
    }

    fun readContentIntoByteArray(file: File): ByteArray {
        val fileInputStream: FileInputStream?
        val bFile = ByteArray(file.length().toInt())
        try {
            //convert file into array of bytes
            fileInputStream = FileInputStream(file)
            fileInputStream.read(bFile)
            fileInputStream.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return bFile
    }

    fun cropBitmap(orgBitmap: Bitmap?, left: Int, top: Int, right: Int, bottom: Int): Bitmap? {
        val width = right - left
        val height = bottom - top

        orgBitmap?.let {
            return try{
                Bitmap.createBitmap(it, left, top, width, height)
            }catch (e: Exception) {
                null
            }
        }
        return null
    }


}
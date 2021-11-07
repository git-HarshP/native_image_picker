package com.example.native_lib_poc

//import io.flutter.embedding.android.FlutterActivity
//class MainActivity: FlutterActivity() {
//}

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.graphics.Bitmap
import android.net.Uri
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File


class MainActivity : FlutterActivity() {

    private val methodChannel = "samples.flutter.dev/image_picker"
    private lateinit var resultTemp: MethodChannel.Result

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannel).setMethodCallHandler { call, result ->
            if (call.method == "pickImage") {
                dispatchTakePictureIntent()
                resultTemp = result
            } else {
                result.notImplemented()
            }
        }
    }


    private val requestImageCapture = 1
    private fun dispatchTakePictureIntent() {
        val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)

//        val f = File(Environment.getExternalStorageDirectory(), "pickedImage.jpg")
//        takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(f))

        try {
            startActivityForResult(takePictureIntent, requestImageCapture)
        } catch (e: ActivityNotFoundException) {
            resultTemp.error(e.message, e.localizedMessage, null)
        }
    }



    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == requestImageCapture && resultCode == Activity.RESULT_OK) {
            val photo = data.extras!!["data"] as Bitmap?
//            imageView.setImageBitmap(photo)
//            knop.setVisibility(Button.VISIBLE)


            // CALL THIS METHOD TO GET THE URI FROM THE BITMAP
            val tempUri: Uri = getImageUri(applicationContext, photo)!!

            // CALL THIS METHOD TO GET THE ACTUAL PATH
            val finalFile = File(getRealPathFromURI(tempUri))
            resultTemp.success(finalFile.path)
        }
    }

    private fun getImageUri(inContext: Context, inImage: Bitmap?): Uri? {
        val outImage = Bitmap.createScaledBitmap(inImage!!, 1000, 1000, true)
        val path = MediaStore.Images.Media.insertImage(inContext.contentResolver, outImage, "Title", null)
        return Uri.parse(path)
    }

    private fun getRealPathFromURI(uri: Uri?): String? {
        var path = ""
        if (contentResolver != null) {
            val cursor: Cursor? = contentResolver.query(uri!!, null, null, null, null)
            if (cursor != null) {
                cursor.moveToFirst()
                val idx: Int = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA)
                path = cursor.getString(idx)
                cursor.close()
            }
        }
        return path
    }
}
package com.mhdaslam790.instafbdownloader

import android.content.ContentResolver
import android.content.ContentValues
import android.net.Uri
import android.os.Build.VERSION
import android.os.Environment
import android.os.ParcelFileDescriptor
import android.provider.MediaStore
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream


class MainActivity : FlutterActivity() {
    private val CHANNEL = "MediaStoreAPI"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "saveFileUsingMediaStoreAPI") {
                val path = call.argument<String>("filepath")
                val nme = call.argument<String>("name")
                saveFile(path = path, nme = nme)
                result.success(null)
            } else {
                result.notImplemented()

            }
        }
    }

    private fun showToast(text: String) {
        val toast = Toast.makeText(this, text, Toast.LENGTH_LONG).show()

        return toast
    }

    private fun saveFile(path: String?, nme: String?) {

        val uriSavedVideo: Uri
        var createdvideo: File? = null
        val resolver: ContentResolver = getContentResolver()


        val videoFileName = "video_" + System.currentTimeMillis() + ".mp4"

        val valuesvideos: ContentValues
        valuesvideos = ContentValues()


        if (VERSION.SDK_INT >= 29) {
            valuesvideos.put(MediaStore.Video.Media.RELATIVE_PATH, "Movies/" + "fb insta downloader")
            valuesvideos.put(MediaStore.Video.Media.TITLE, videoFileName)
            valuesvideos.put(MediaStore.Video.Media.DISPLAY_NAME, videoFileName)
            valuesvideos.put(MediaStore.Video.Media.MIME_TYPE, "video/mp4")
            valuesvideos.put(MediaStore.Video.Media.DATE_ADDED, System.currentTimeMillis() / 1000)
            val collection = MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            uriSavedVideo = resolver.insert(collection, valuesvideos)!!
        } else {
            val directory = Environment.getExternalStorageDirectory().absolutePath + File.separator + "Movies" + "/" + "fb insta downloader"
            var file = File(directory)
            if (!file.exists()) {
                file.mkdirs()
            }
            createdvideo = File(directory, videoFileName)
            valuesvideos.put(MediaStore.Video.Media.TITLE, videoFileName)
            valuesvideos.put(MediaStore.Video.Media.DISPLAY_NAME, videoFileName)
            valuesvideos.put(MediaStore.Video.Media.MIME_TYPE, "video/mp4")
            valuesvideos.put(MediaStore.Video.Media.DATE_ADDED, System.currentTimeMillis() / 1000)
            valuesvideos.put(MediaStore.Video.Media.DATA, createdvideo.absolutePath)
            uriSavedVideo = getContentResolver().insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, valuesvideos)!!
        }
        if (VERSION.SDK_INT >= 29) {
            valuesvideos.put(MediaStore.Video.Media.DATE_TAKEN, System.currentTimeMillis())
            valuesvideos.put(MediaStore.Video.Media.IS_PENDING, 1)
        }


        val pfd: ParcelFileDescriptor

        try {

            pfd = getContentResolver().openFileDescriptor(uriSavedVideo, "w")!!
            val out = FileOutputStream(pfd.fileDescriptor)

            // get the already saved video as fileinputstream

            // The Directory where your file is saved

            //Directory and the name of your video file to copy

            val videoFile = File(path, nme)
            val `in` = FileInputStream(videoFile)
            val buf = ByteArray(8192)
            var len: Int
            while (`in`.read(buf).also { len = it } > 0) {
                out.write(buf, 0, len)
            }
            out.close()
            `in`.close()
            pfd.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        if (VERSION.SDK_INT >= 29) {
            valuesvideos.clear()
            valuesvideos.put(MediaStore.Video.Media.IS_PENDING, 0)
            getContentResolver().update(uriSavedVideo, valuesvideos, null, null)
        }


    }
}
package com.dcodeai.dcodeai_playground

import com.chaquo.python.PyException
import com.chaquo.python.PyObject
import com.chaquo.python.Python
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception
import java.util.concurrent.Executors

import java.util.concurrent.ExecutorService

class MainActivity : FlutterActivity() {

    //  * This will run python code consisting of error and result output...
    fun _runPythonTextCode(data: Map<String, Any?>): Map<String, Any?> {
        val _returnOutput: MutableMap<String, Any?> = HashMap()

        val _python: Python = Python.getInstance()

        val _console: PyObject = _python.getModule("script")
        val _sys: PyObject = _python.getModule("sys")
        val _io: PyObject = _python.getModule("io")

        return try {
            val _textOutputStream: PyObject = _io.callAttr("StringIO")
            _sys["stdout"] = _textOutputStream
            _console.callAttrThrows("mainTextCode", data["code"])
            _returnOutput["textOutput"] = _textOutputStream.callAttr("getvalue").toString()
            _returnOutput
        } catch (e: PyException) {
            
            _returnOutput["textOutput"] = e.message.toString()
            _returnOutput
        }
    }
    
    //  * This will run python code consisting of error and result output...
    fun _runPythonNLTKCode(data: Map<String, Any?>): Map<String, Any?> {
        val _returnOutput: MutableMap<String, Any?> = HashMap()

        val _python: Python = Python.getInstance()

        val _console: PyObject = _python.getModule("script")
        val _sys: PyObject = _python.getModule("sys")
        val _io: PyObject = _python.getModule("io")

        return try {
            val _textOutputStream: PyObject = _io.callAttr("StringIO")
            _sys["stdout"] = _textOutputStream
            _console.callAttrThrows("mainNLTK", data["code"])
            _returnOutput["textOutput"] = _textOutputStream.callAttr("getvalue").toString()
            _returnOutput
        } catch (e: PyException) {
            
            _returnOutput["textOutput"] = e.message.toString()
            _returnOutput
        }
    }

    //  * This will run python code consisting of error or Image output...
    fun _runPythonCVCode(data: Map<String, Any?>): Map<String, Any?> {
        val _returnOutput: MutableMap<String, Any?> = HashMap()

        val _python: Python = Python.getInstance()

        val _console: PyObject = _python.getModule("script")
        val _sys: PyObject = _python.getModule("sys")
        val _io: PyObject = _python.getModule("io")

        return try {
            val _textOutputStream: PyObject = _io.callAttr("StringIO")
            _sys["stdout"] = _textOutputStream
            val _imgOutputStream: PyObject = _console.callAttrThrows("mainImageProcessing", data["code"], data["inputImg"])
            _returnOutput["textOutput"] = _textOutputStream.callAttr("getvalue").toString()
            _returnOutput["graphOutput"] = _imgOutputStream.toJava(ByteArray::class.java)
            _returnOutput
        } catch (e: PyException) {
             if(e.message.toString().equals("TimeoutError: ")){
                _returnOutput["error"] = "TimeoutError : The code should be executed within 30 seconds. kindly, optimize your code."
            }else{
                _returnOutput["error"] = "SytaxError : Kindly check syntax of your code."        
            }
            _returnOutput
        }
    }

    //  * This will run python code consisting of error or RGB Image output...
    fun _runPythonRGBCode(data: Map<String, Any?>): Map<String, Any?> {
        val _returnOutput: MutableMap<String, Any?> = HashMap()

        val _python: Python = Python.getInstance()

        val _console: PyObject = _python.getModule("script")
        val _sys: PyObject = _python.getModule("sys")
        val _io: PyObject = _python.getModule("io")
        
        
        return try {
            
            val _textOutputStream: PyObject = _io.callAttr("StringIO")
            _sys["stdout"] = _textOutputStream
            val _imgOutputStream: PyObject = _console.callAttrThrows("mainRGBProcessing", data["code"], data["inputImg"])
            _returnOutput["textOutput"] = _textOutputStream.callAttr("getvalue").toString()
            val _imageList: MutableList<PyObject> = _imgOutputStream.asList()
            _returnOutput["graphOutputR"] = _imageList[0].toJava(ByteArray::class.java)
            _returnOutput["graphOutputG"] = _imageList[1].toJava(ByteArray::class.java)
            _returnOutput["graphOutputB"] = _imageList[2].toJava(ByteArray::class.java)
            
            _returnOutput
        } catch (e: PyException) {
            
            if(e.message.toString().equals("TimeoutError: ")){
                _returnOutput["error"] = "TimeoutError : The code should be executed within 30 seconds. kindly, optimize your code."
            }else{
                _returnOutput["error"] = "SytaxError : Kindly check syntax of your code."        
            }
            _returnOutput
        }
    }

    //  * This will run python code consisting of graph,error,result output...
    fun _runPythonMatplotCode(data: Map<String, Any?>): Map<String, Any?> {
        val _returnOutput: MutableMap<String, Any?> = HashMap()

        val _python: Python = Python.getInstance()

        val _console: PyObject = _python.getModule("script")
        val _sys: PyObject = _python.getModule("sys")
        val _io: PyObject = _python.getModule("io")

        return try {
            val _textOutputStream: PyObject = _io.callAttr("StringIO")
            _sys["stdout"] = _textOutputStream
            val _imgOutputStream: PyObject = _console.callAttrThrows("mainMatplotlib", data["code"])
            _returnOutput["textOutput"] = _textOutputStream.callAttr("getvalue").toString()
            _returnOutput["graphOutput"] = _imgOutputStream.toJava(ByteArray::class.java)
            _returnOutput
        } catch (e: PyException) {
            if(e.message.toString().equals("TimeoutError: ")){
                _returnOutput["error"] = "TimeoutError : The code should be executed within 30 seconds. kindly, optimize your code."
            }else{
                _returnOutput["error"] = "SytaxError : Kindly check syntax of your code."        
            }
            _returnOutput
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "runPython").setMethodCallHandler { call, result ->
            if (call.method == "runPythonScript") {
                try {
                    val data: Map<String, Any?> = call.arguments()
                    val _result: Map<String, Any?> = _runPythonTextCode(data)
                    result.success(_result)
                } catch (e: Exception) {
                    val _result: MutableMap<String, Any?> = HashMap()
                    _result["textOutput"] = e.message.toString()
                    result.success(_result)
                }
            }else if (call.method == "runPythonNLTKScript") {
                try {
                    val data: Map<String, Any?> = call.arguments()
                    val _result: Map<String, Any?> = _runPythonNLTKCode(data)
                    result.success(_result)
                } catch (e: Exception) {
                    val _result: MutableMap<String, Any?> = HashMap()
                    _result["textOutput"] = e.message.toString()
                    result.success(_result)
                }
            }  
            else if (call.method == "runPythonCVScript") {
                try {
                    val data: Map<String, Any?> = call.arguments()
                    val _result: Map<String, Any?> = _runPythonCVCode(data)
                    result.success(_result)
                } catch (e: Exception) {
                    val _result: MutableMap<String, Any?> = HashMap()
                    _result["error"] = e.message.toString()
                    result.success(_result)
                }
            } else if (call.method == "runPythonRGBScript") {
                try {
                    val data: Map<String, Any?> = call.arguments()
                    val _result: Map<String, Any?> = _runPythonRGBCode(data)
                    result.success(_result)
                } catch (e: PyException) {
                    val _result: MutableMap<String, Any?> = HashMap()
                    _result["error"] = e.message.toString()
                    result.success(_result)
               }
            } else if (call.method == "runPythonMatplotlibScript") {
                try {
                    val data: Map<String, Any?> = call.arguments()
                    val _result: Map<String, Any?> = _runPythonMatplotCode(data)
                    result.success(_result)
                } catch (e: PyException) {
                    val _result: MutableMap<String, Any?> = HashMap()
                    _result["error"] = e.message.toString()
                    result.success(_result)
               }
            } 
        }
    }
}

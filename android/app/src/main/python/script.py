import io,os,cv2,sys,time,threading,ctypes,inspect,queue,traceback
import matplotlib.pyplot as plt
import PIL.Image as Image
import numpy as np
from os.path import dirname

my_queue = queue.Queue()

def _async_raise(tid, exctype):
    tid = ctypes.c_long(tid)
    if not inspect.isclass(exctype):
        exctype = type(exctype)
    res = ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, ctypes.py_object(exctype))
    if res == 0:
        raise ValueError("invalid thread id")
    elif res != 1:
        ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, None)
        raise SystemError("Timeout Exception")

def stop_thread(thread):
    _async_raise(thread.ident, SystemExit)

def nltk_thread_run(code):
    try:
        os.environ["NLTK_DATA"] = f"{dirname(__file__)}/nltk_data"
        env={}
        exec(code,env,env)
    except Exception as e:
        print(e)
    
def storeInQueue(f):
  def wrapper(*args):
    my_queue.put(f(*args))
  return wrapper

@storeInQueue
def cv_thread_run(code,imageBytes):

    #   Convert Byte Code to PIL Image
    image = Image.open(io.BytesIO(imageBytes))

    #   Convert Byte Code to nd array
    opencvImage = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

    local_var = {
        'opencvImage': opencvImage,
    }

    exec(code, globals(), local_var)
    return local_var['f'].getvalue()

@storeInQueue
def cv_rgb_thread_run(code,imageBytes):
    local_var = {}

    #   Convert Byte Code to PIL Image
    image = Image.open(io.BytesIO(imageBytes))

    #   Convert Byte Code to nd array
    opencvImage = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

    local_var = {
        'opencvImage': opencvImage,
    }

    #   Do cv operation
    exec(code, globals(), local_var)
    return local_var['rImg'].getvalue(), local_var['gImg'].getvalue(), local_var['bImg'].getvalue()

@storeInQueue
def matplotlib_thread_run(code):
    f = io.BytesIO()
    local_var = {
        'f': f,
    }
    exec(code,globals(),local_var)
    plt.savefig(f, format="png")
    return local_var['f'].getvalue()
    
#   This mainMatplotlib function will be used for Text and Graph based outputs...
def mainMatplotlib(code):
    global thread1
    thread1 = threading.Thread(target=matplotlib_thread_run, args=(code,),daemon=True)
    thread1.start()
    timeout = 15 # seconds
    thread1_start_time = time.time()
    while thread1.is_alive():
        if time.time() - thread1_start_time > timeout:
            # thread does not provide stop method, so just exit to kill process
            stop_thread(thread1)
            raise TimeoutError
        time.sleep(1)
    return my_queue.get(False)
     
def text_thread_run(code):
    try:
        env={}
        exec(code, env, env)
    except Exception as e:
        print(e)

#   This is the code to run NLTK functions...
def mainNLTK(code):
    global thread1
    thread1 = threading.Thread(target=nltk_thread_run, args=(code,),daemon=True)
    thread1.start()
    timeout = 15 # seconds
    thread1_start_time = time.time()
    while thread1.is_alive():
        if time.time() - thread1_start_time > timeout:
            # thread does not provide stop method, so just exit to kill process
            stop_thread(thread1)
            raise TimeoutError
        time.sleep(1)
   
    
#   This is the code to run Text functions...
def mainTextCode(code):
    global thread1
    thread1 = threading.Thread(target=text_thread_run, args=(code,),daemon=True)
    thread1.start()
    timeout = 15 # seconds
    thread1_start_time = time.time()
    while thread1.is_alive():
        if time.time() - thread1_start_time > timeout:
            stop_thread(thread1)
            raise TimeoutError
        time.sleep(1)

#   This mainImageProcessing function will be used for Image based outputs...
def mainImageProcessing(code, imageBytes):
    global thread1
    thread1 = threading.Thread(target=cv_thread_run, args=(code,imageBytes,),daemon=True)
    thread1.start()
    timeout = 15 # seconds
    thread1_start_time = time.time()
    while thread1.is_alive():
        if time.time() - thread1_start_time > timeout:
            stop_thread(thread1)
            raise TimeoutError
        time.sleep(1)
    return my_queue.get(False)
    
#   This function returns Red-Green-Blue Image from single Image...
def mainRGBProcessing(code, imageBytes):
    global thread1
    thread1 = threading.Thread(target=cv_rgb_thread_run, args=(code,imageBytes,),daemon=True)
    thread1.start()
    timeout = 15 # seconds
    thread1_start_time = time.time()
    while thread1.is_alive():
        if time.time() - thread1_start_time > timeout:
            stop_thread(thread1)
            raise TimeoutError
        time.sleep(1)
    return my_queue.get(False)
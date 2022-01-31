from flask import Flask, request, jsonify, send_file
import werkzeug    
import base64
from io import BytesIO
from PIL import Image
import os
import model
import numpy as np


app = Flask(__name__)



@app.route('/upload', methods=['POST','GET'])
def upload():
    if(request.method == 'POST'):
        styleimage = request.files['styleimage']
        objectimage = request.files['objectimage']
        stylefilename = werkzeug.utils.secure_filename(styleimage.filename)
        objectfilename = werkzeug.utils.secure_filename(objectimage.filename)
        styleimage.save("./uploads/style"+stylefilename)
        objectimage.save("./uploads/object"+objectfilename)

        #return image as bytedata
        # im_arr: image in Numpy one-dim array format.
        cwd = os.getcwd()
        output_img = model.main(stylefilename, objectfilename)
        # img = Image.open(f'{cwd}/outputs/test.jpeg')
        img = Image.fromarray((output_img * 255).astype(np.uint8))
        #img = Image.fromarray(output_img)
        im_file = BytesIO()
        img.save(im_file, format="JPEG")
        im_bytes = im_file.getvalue()  # im_bytes: image in binary format.
        im_b64 = base64.b64encode(im_bytes)
        return jsonify({'image': im_b64.decode('utf-8')})

    else:
        img = Image.open(f'{cwd}/outputs/error.jpeg')
        im_file = BytesIO()
        img.save(im_file, format="JPEG")
        im_bytes = im_file.getvalue()  # im_bytes: image in binary format.
        im_b64 = base64.b64encode(im_bytes)
        return jsonify({'image': im_b64.decode('utf-8')})

if __name__=='__main__':
    app.run(debug = True, port=4000)
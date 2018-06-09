#!/usr/bin/python

import tensorflow as tf, sys
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import requests
from os.path import basename
import numpy as np
import oauth2 as oauth
import json
import urllib
from collections import namedtuple
import subprocess
# 1 = 1386,228
# 2 = 1475,270
# 3 = 1475,387
# 4 = 1386,434
# 5 = 1295,387  
# 6 = 1295,270

AUTHENTICATION="https://api.twitter.com/oauth2/token"
REQUEST_TOKEN="https://api.twitter.com/oauth/request_token"
AUTHORIZE_URL="https://api.twitter.com/oauth/authorize"
ACCESS_TOKEN_URL="https://api.twitter.com/oauth/access_token"
twitterapi=False

CONSUMER_KEY=""
CONSUMER_SECRET=""
ACCESS_KEY=""
ACCESS_SECRET=""


PORT_NUMBER=9091
ResponseStatus = namedtuple("ResponseStatus", ["code", "message"])
ResponseData = namedtuple("ResponseData", ["status", "content_type", "data_stream"])
HTTP_STATUS = {"OK": ResponseStatus(code=200, message="OK"),
    "BAD_REQUEST": ResponseStatus(code=400, message="Bad request"),
    "NOT_FOUND": ResponseStatus(code=404, message="Not found"),
    "INTERNAL_SERVER_ERROR": ResponseStatus(code=500, message="Internal server error")}


RUNES={"1":"1386 228","2":"1475 270","3":"1475 387","4":"1386 434","5":"1295 387","6":"1295 270"}

class myHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        current_path=self.path
        print current_path
        if current_path.startswith('/power') :
            response = self.handle_power(current_path[-1])
            self.send_headers(response.status, response.content_type)
            self.wfile.write(response.data_stream)
            return
        if current_path.startswith('/mobile'):
            print "In mobile"
            response = self.handle_mobile(current_path)
            self.send_headers(response.status, response.content_type)
            self.wfile.write(response.data_stream)
            return
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        scores = getprediction(basename(self.path))
        print ('%s (score =%.5f)' % scores)
        self.wfile.write(scores[0])
        return
    
    def do_POST(self):
        current_path = self.path
        if  current_path.startswith('/mobile/clientstart'):
            response = self.handle_mobile_post(current_path)
            self.send_headers(response.status, response.content_type)
            self.wfile.write(response.data_stream)
            return
        if current_path.startswith('/mobile/login'):
            response = self.handle_mobile_login(current_path)
            self.send_headers(response.status, response.content_type)
            self.wfile.write(response.data_stream)
            return
        print (self.headers)
        content_len = int(self.headers.getheader('content-length', 0))
        post_body = self.rfile.read(content_len)
        print post_body
        if twitterapi is True:
            self.oauth_req('https://api.twitter.com/1.1/statuses/update.json', ACCESS_KEY, ACCESS_SECRET, "POST", urllib.urlencode({"status":post_body,"wrap_links":True}))
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write('success')
        return

    def handle_power(self, arg0):
        return ResponseData(status=HTTP_STATUS["OK"], content_type="text/plain", data_stream=RUNES[arg0])
    def handle_mobile(self, arg0):
        arr = arg0[1:].split('/')
        print arr
        if len(arr) == 1 and arr[0] == 'mobile':
            with open("index.dec", 'r') as indexfile:
                data = indexfile.read()
                return ResponseData(status=HTTP_STATUS['OK'], content_type="text/html, charset=UTF-8", data_stream=data)
        if len(arr) > 2:
            if arr[1] == 'kill':
                return self.handle_kill(arr[2])
        return ResponseData(status=HTTP_STATUS["OK"], content_type="text/html",
                data_stream='<html><body>hello world</body></html>')
    def handle_kill(self, arg0):
        print "kill process"
        client_run = ['/home/prasad/workspace/summonerswar/kill_client.sh']
        client_run.append(arg0)
        command = ' '.join(client_run)
        print command  # ['/home/prasad/workspace/summonerswar/dissy.sh']
        subprocess.call("nohup "+command + " > /dev/null 2>&1 & ", shell=True)
        return ResponseData(status=HTTP_STATUS["OK"], content_type="text/html",
                data_stream='successfully killed process')
    def handle_mobile_post(self, arg0):
        content_len = int(self.headers.getheader('content-length', 0))
        post_body = self.rfile.read(content_len)
        activity= json.loads(post_body)
        client_run = ['/home/prasad/workspace/summonerswar/client.sh']
        if 'device' in activity:
            client_run.append('-d')
            client_run.append(activity['device'].encode('ascii', 'ignore'))
            client_run.append('-i')
            client_run.append(activity['device'].encode('ascii', 'ignore'))
        if 'pvp' in activity:
            client_run.append('--pvp')
        if 'norune' in activity:
            client_run.append('--norune')
        if 'exit' in activity:
            client_run.append('--exit')
        if 'time' in activity:
            client_run.append('-t')
            client_run.append(activity['time'].encode('ascii', 'ignore'))
        if len(client_run) > 1:
            command = ' '.join(client_run)
            print command  # ['/home/prasad/workspace/summonerswar/dissy.sh']
            subprocess.call("nohup "+command + " > /dev/null 2>&1 & ", shell=True)
        return ResponseData(status=HTTP_STATUS["OK"], content_type="text/html",
                data_stream='<html><body>hello world</body></html>')
    def handle_mobile_login(self, arg0):
        content_len = int(self.headers.getheader('content-length', 0))
        post_body = self.rfile.read(content_len)
        activity= json.loads(post_body)
        client_run = ['/home/prasad/workspace/summonerswar/client.sh']
        if 'device' in activity:
            client_run.append('-d')
            client_run.append(activity['device'].encode('ascii', 'ignore'))
            client_run.append('-i')
            client_run.append(activity['device'].encode('ascii', 'ignore'))
        if 'login' in activity:
            client_run.append('--login')
            login_cred = activity['login']
            client_run.append(login_cred.encode('ascii', 'ignore'))
            client_run.append('prasadi01')
        if len(client_run) > 1:
            command = ' '.join(client_run)
            print command  # ['/home/prasad/workspace/summonerswar/dissy.sh']
            subprocess.call("nohup "+command + " > /dev/null 2>&1 & ", shell=True)
        return ResponseData(status=HTTP_STATUS["OK"], content_type="text/plain",
                data_stream=command)            
        

    def send_headers(self, status, content_type):
        self.send_response(status.code, status.message)
        self.send_header('Content-type', content_type)
        self.end_headers()

    def oauth_req(self, url, key, secret, http_method="GET", post_body="", http_headers=None):
        consumer = oauth.Consumer(key=CONSUMER_KEY, secret=CONSUMER_SECRET)
        token = oauth.Token(key=key, secret=secret)
        client = oauth.Client(consumer, token)
        resp, content = client.request( url, method=http_method, body=post_body, headers=http_headers )
        return content

def getprediction(arg0):
    image_data = tf.gfile.FastGFile(arg0 + ".jpg", 'rb').read()
    with tf.Session() as session:
        softmax_tensor = session.graph.get_tensor_by_name('final_result:0')

        predictions = session.run(softmax_tensor, \
                {'DecodeJpeg/contents:0':image_data})
        top_k=predictions[0].argsort()[-len(predictions[0]):][::-1]
        scores = "";
        for node_id in top_k:
            human_string = label_lines[node_id]
            score = predictions[0][node_id]
            return (human_string, score)
        return ()



image_path = "screen.jpg"
label_lines = [line.rstrip() for line in tf.gfile.GFile("./tf_files/retrained_labels.txt")]

with tf.gfile.FastGFile("./tf_files/retrained_graph.ph", 'rb') as f:
    graph_def = tf.GraphDef()    
    graph_def.ParseFromString(f.read())
    _ = tf.import_graph_def(graph_def, name='')


try:
    server = HTTPServer(('', PORT_NUMBER), myHandler)
    print 'Server Started'
    server.serve_forever()
except KeyboardInterrupt:
        print '^C received'
        server.socket.close()

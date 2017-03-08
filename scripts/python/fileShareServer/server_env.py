#!/usr/bin/python
#coding:utf8

import sys
import optparse
import SimpleHTTPServer
import SocketServer
import os

from __init__ import __ver__
from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer

def main():
    """帮助理解参数选项如何工作
       迅速建立ftp/http server, 方便user访问"""
    PORT = 8000
    usage = "python %prog -t http [options]"
    parser = optparse.OptionParser(usage)
    parser.add_option('-t', '--type', default="ftp", metavar="SERVER TYPE",
                        help="specify which server type you want to create")
    parser.add_option('-v', '--version', action='store_true',
                        help="print script version and exit")
    options, args = parser.parse_args()
    if options.version:
        sys.exit("version: %s" % __ver__)
    if options.type == "ftp":
        print "ftp server is to be creating"
        authorizer = DummyAuthorizer()
        authorizer.add_user('user', '12345', os.getcwd(), perm='elradfmwM')
        authorizer.add_anonymous(os.getcwd())
        handler = FTPHandler
        handler.authorizer = authorizer
        handler.banner = "pyftpdlib based ftpd ready."
        address = ('', 2121)
        server = FTPServer(address, handler)
        server.max_cons = 256
        server.max_cons_per_ip = 5
        try:
            server.serve_forever()
        finally:
            server.close_all()

    elif options.type == "http":
        print "http server is to be creating"
        handler = SimpleHTTPServer.SimpleHTTPRequestHandler
        httpd = SocketServer.TCPServer(("", PORT), handler)
        print "serving at port:", PORT
        try:
            httpd.serve_forever()
        except KeyboardInterrupt, msg:
            print "http server is interrupted by user"
        finally:
            httpd.shutdown()
            print "shut down http server"
    else:
        print "Please enter correct server type..."

if __name__ == "__main__":
    main()

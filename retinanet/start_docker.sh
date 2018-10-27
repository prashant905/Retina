#!/bin/bash
nvidia-docker run -it -p 8888:8888 -p 6006:6006 -v /home/zmc/prashant:/notebooks needle


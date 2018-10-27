"""
Copyright 2017-2018 Fizyr (https://fizyr.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import cv2
import numpy as np

def bb_intersection_over_union(boxA, boxB):
	# determine the (x, y)-coordinates of the intersection rectangle
	xA = max(boxA[0], boxB[0])
	yA = max(boxA[1], boxB[1])
	xB = min(boxA[2], boxB[2])
	yB = min(boxA[3], boxB[3])
 
	# compute the area of intersection rectangle
	interArea = (xB - xA + 1) * (yB - yA + 1)
 
	# compute the area of both the prediction and ground-truth
	# rectangles
	boxAArea = (boxA[2] - boxA[0] + 1) * (boxA[3] - boxA[1] + 1)
	boxBArea = (boxB[2] - boxB[0] + 1) * (boxB[3] - boxB[1] + 1)
 
	# compute the intersection over union by taking the intersection
	# area and dividing it by the sum of prediction + ground-truth
	# areas - the interesection area
	iou = interArea / float(boxAArea + boxBArea - interArea)
 
	# return the intersection over union value
	return iou

def draw_iou(image,gt,detections,generator=None):
    """ Draws detections in an image.

    # Arguments
        image      : The image to draw on.
        detections : A [N, 4 + num_classes] matrix (x1, y1, x2, y2, cls_1, cls_2, ...).
        color      : The color of the boxes.
        generator  : (optional) Generator which can map label to class name.
    """
    grn = np.array(gt).astype(int)
    grn=grn.flatten()
    print("grn",grn) 
    print(type(grn))
    pred = np.array(detections).astype(int)
    pred = pred.flatten()
    print("pred",pred)
    print(type(pred))
    iou = bb_intersection_over_union(grn,pred)
    cv2.putText(image, "IoU: {:.4f}".format(iou), (10, 30),
		cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

def draw_box(image, box, color, thickness=2):
    """ Draws a box on an image with a given color.

    # Arguments
        image     : The image to draw on.
        box       : A list of 4 elements (x1, y1, x2, y2).
        color     : The color of the box.
        thickness : The thickness of the lines to draw a box with.
    """
    b = np.array(box).astype(int)
    cv2.rectangle(image, (b[0], b[1]), (b[2], b[3]), color, thickness)


def draw_caption(image, box, caption):
    """ Draws a caption above the box in an image.

    # Arguments
        image   : The image to draw on.
        box     : A list of 4 elements (x1, y1, x2, y2).
        caption : String containing the text to draw.
    """
    b = np.array(box).astype(int)
    cv2.putText(image, caption, (b[0], b[1] - 10), cv2.FONT_HERSHEY_PLAIN, 1, (0, 0, 0), 2)
    cv2.putText(image, caption, (b[0], b[1] - 10), cv2.FONT_HERSHEY_PLAIN, 1, (255, 255, 255), 1)


def draw_boxes(image, boxes, color, thickness=2):
    """ Draws boxes on an image with a given color.

    # Arguments
        image     : The image to draw on.
        boxes     : A [N, 4] matrix (x1, y1, x2, y2).
        color     : The color of the boxes.
        thickness : The thickness of the lines to draw boxes with.
    """
    for b in boxes:
        draw_box(image, b, color, thickness=thickness)


def draw_detections(image, detections, color=(255, 0, 0), generator=None):
    """ Draws detections in an image.

    # Arguments
        image      : The image to draw on.
        detections : A [N, 4 + num_classes] matrix (x1, y1, x2, y2, cls_1, cls_2, ...).
        color      : The color of the boxes.
        generator  : (optional) Generator which can map label to class name.
    """
    draw_boxes(image, detections, color=color)

    # draw labels
    for d in detections:
        label   = np.argmax(d[4:])
        score   = d[4 + label]
        caption = (generator.label_to_name(label) if generator else label) + ': {0:.2f}'.format(score)
        draw_caption(image, d, caption)


def draw_annotations(image, annotations, color=(0, 255, 0), generator=None):
    """ Draws annotations in an image.

    # Arguments
        image       : The image to draw on.
        annotations : A [N, 5] matrix (x1, y1, x2, y2, label).
        color       : The color of the boxes.
        generator   : (optional) Generator which can map label to class name.
    """
    draw_boxes(image, annotations, color)

    # draw labels
    for b in annotations:
        label   = b[4]
        caption = '{}'.format(generator.label_to_name(label) if generator else label)
        draw_caption(image, b, caption)

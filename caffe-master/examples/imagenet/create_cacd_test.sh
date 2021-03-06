#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

rm -r $CAFFE_ROOT/examples/imagenet/cacd_test_lmdb
EXAMPLE=$CAFFE_ROOT/examples/imagenet
DATA1=$CAFFE_ROOT/deepal/cacd_svm/finetune.txt
DATA2=$DATA_ROOT/cacd/test.txt
TOOLS=$CAFFE_ROOT/build/tools

TRAIN_DATA_ROOT=$DATA_ROOT/cacd/cacd_train/
VAL_DATA_ROOT=$DATA_ROOT/cacd/cacd_test/

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=true
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$TRAIN_DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet training data is stored."
  exit 1
fi

if [ ! -d "$VAL_DATA_ROOT" ]; then
  echo "Error: VAL_DATA_ROOT is not a path to a directory: $VAL_DATA_ROOT"
  echo "Set the VAL_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet validation data is stored."
  exit 1
fi

echo "Creating val lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $VAL_DATA_ROOT \
    $DATA2 \
    $EXAMPLE/cacd_test_lmdb

echo "Done."

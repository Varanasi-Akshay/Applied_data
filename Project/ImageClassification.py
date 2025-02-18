from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import (Conv2D,
                          Dense,
                          LeakyReLU,
                          BatchNormalization, 
                          MaxPooling2D, 
                          Dropout,
                          Flatten)
from keras.optimizers import RMSprop
from keras.callbacks import ModelCheckpoint, TensorBoard
import PIL.Image
from datetime import datetime as dt

start = dt.now()

# fruits categories
fruit_list = ["Kiwi", "Banana", "Plum", "Apricot", "Avocado", "Cocos", "Clementine", "Mandarine", "Orange",
                "Limes", "Lemon", "Peach", "Plum", "Raspberry", "Strawberry", "Pineapple", "Pomegranate"]
# number of output classes (i.e. fruits)
output_n = len(fruit_list)
# image size to scale down to (original images are 100 x 100 px)
img_width = 20
img_height = 20
target_size = (img_width, img_height)
# image RGB channels number
channels = 3
# path to image folders
path = "path/to/folder/with/data"
train_image_files_path = path + "fruits-360/Training"
valid_image_files_path = path + "fruits-360/Test"

## input data augmentation/modification
# training images
train_data_gen = ImageDataGenerator(
  rescale = 1./255
)
# validation images
valid_data_gen = ImageDataGenerator(
  rescale = 1./255
)

## getting data
# training images
train_image_array_gen = train_data_gen.flow_from_directory(train_image_files_path,                                                            
                                                           target_size = target_size,
                                                           classes = fruit_list, 
                                                           class_mode = 'categorical',
                                                           seed = 42)

# validation images
valid_image_array_gen = valid_data_gen.flow_from_directory(valid_image_files_path, 
                                                           target_size = target_size,
                                                           classes = fruit_list,
                                                           class_mode = 'categorical',
                                                           seed = 42)

## model definition
# number of training samples
train_samples = train_image_array_gen.n
# number of validation samples
valid_samples = valid_image_array_gen.n
# define batch size and number of epochs
batch_size = 32
epochs = 10

# initialise model
model = Sequential()

# add layers
# input layer
model.add(Conv2D(filters = 32, kernel_size = (3,3), padding = 'same', input_shape = (img_width, img_height, channels), activation = 'relu'))
# hiddel conv layer
model.add(Conv2D(filters = 16, kernel_size = (3,3), padding = 'same'))
model.add(LeakyReLU(.5))
model.add(BatchNormalization())
# using max pooling
model.add(MaxPooling2D(pool_size = (2,2)))
# randomly switch off 25% of the nodes per epoch step to avoid overfitting
model.add(Dropout(.25))
# flatten max filtered output into feature vector
model.add(Flatten())
# output features onto a dense layer
model.add(Dense(units = 100, activation = 'relu'))
# randomly switch off 25% of the nodes per epoch step to avoid overfitting
model.add(Dropout(.5))
# output layer with the number of units equal to the number of categories
model.add(Dense(units = output_n, activation = 'softmax'))

# compile the model
model.compile(loss = 'categorical_crossentropy', 
              metrics = ['accuracy'], 
              optimizer = RMSprop(lr = 1e-4, decay = 1e-6))

# train the model
hist = model.fit_generator(
  # training data
  train_image_array_gen,

  # epochs
  steps_per_epoch = train_samples // batch_size, 
  epochs = epochs, 

  # validation data
  validation_data = valid_image_array_gen,
  validation_steps = valid_samples // batch_size,

  # print progress
  verbose = 2,
  callbacks = [
    # save best model after every epoch
    ModelCheckpoint("fruits_checkpoints.h5", save_best_only = True),
    # only needed for visualising with TensorBoard
    TensorBoard(log_dir = "fruits_logs")
  ]
)

df_out = {'acc': hist.history['acc'][epochs - 1], 'val_acc': hist.history['val_acc'][epochs - 1], 'elapsed_time': (dt.now() - start).seconds}
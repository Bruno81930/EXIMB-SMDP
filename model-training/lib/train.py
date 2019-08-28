import pandas as pd
import numpy as np
from scipy import stats
import tensorflow as tf
import matplotlib.pyplot as plt
import pickle
from sklearn.metrics import confusion_matrix, precision_recall_curve
from sklearn.metrics import recall_score, classification_report, auc, roc_curve
from sklearn.metrics import precision_recall_fscore_support, f1_score
from keras.models import Model, load_model
from keras.layers import Input, Dense
from keras.callbacks import ModelCheckpoint, TensorBoard
from keras import regularizers

class AbstractTrainer(object):
    def __init__(self, nb_epoch, batch_size, learning_rate, dataset_dir, model_dir):
        self._nb_epoch = nb_epoch
        self._batch_size = batch_size
        self._train_x = pd.read_csv(dataset_dir + "train_x.csv")
        self._test_x = pd.read_csv(dataset_dir + "test_x.csv")
        self._train_x = self._train_x.drop(self._train_x.columns[0], axis=1)
        self._test_x = self._test_x.drop(self._test_x.columns[0], axis=1)
        self._model_dir = model_dir

    def train_autoencoder_0(self, input_dim, input_layer):
        encoding_dim = int(input_dim/2)
        hidden_dim = int(encoding_dim/2)
        encoder = Dense(encoding_dim, activation="sigmoid")(input_layer)
        hidden_layer = Dense(hidden_dim, activation="sigmoid")(encoder)
        return hidden_layer
    
    def train_autoencoder_1(self, input_dim, input_layer):
        encoding_dim = int(input_dim/2)
        hidden_dim = int(encoding_dim/2)
        encoder = Dense(encoding_dim, activation="relu")(input_layer)
        hidden_layer = Dense(hidden_dim, activation="relu")(encoder)
        return hidden_layer
    
    def train_autoencoder_2(self, input_dim, input_layer):
        encoding_dim = int(input_dim/2)
        hidden_dim = int(encoding_dim/2)
        encoder = Dense(encoding_dim, activation="tanh")(input_layer)
        hidden_layer = Dense(hidden_dim, activation="tanh")(encoder)
        return hidden_layer
    
    def train_autoencoder_3(self, input_dim, input_layer):
        encoding_dim = int(input_dim/2)
        hidden_dim = int(encoding_dim/2)
        mid_dim = int(hidden_dim/2)

        encoder = Dense(encoding_dim, activation="relu")(input_layer)
        hidden_layer = Dense(hidden_dim, activation="relu")(encoder)
        hidden_layer = Dense(mid_dim, activation="relu")(hidden_layer)
        hidden_layer = Dense(hidden_dim, activation="relu")(hidden_layer)
        return hidden_layer

    def train_autoencoder_4(self, input_dim, input_layer):
        encoding_dim = int(input_dim/2)
        hidden_dim = int(encoding_dim/2)
        mid_dim = int(hidden_dim/2)
        unitary_dim = 1

        encoder = Dense(encoding_dim, activation="relu")(input_layer)
        hidden_layer = Dense(hidden_dim, activation="relu")(encoder)
        hidden_layer = Dense(mid_dim, activation="relu")(hidden_layer)
        hidden_layer = Dense(unitary_dim, activation="relu")(hidden_layer)
        hidden_layer = Dense(mid_dim, activation="relu")(hidden_layer)
        hidden_layer = Dense(hidden_dim, activation="relu")(hidden_layer)
        return hidden_layer
    
    def compile(self, autoencoder):
        autoencoder.compile(metrics=['accuracy'],
                    loss='mean_squared_error',
                    optimizer='adam')
        
    def get_checkpoint_for(self, model_filename):
        model_path = self._model_dir + model_filename
        return ModelCheckpoint(filepath=model_path,
                    save_best_only=True,
                    verbose=0)

    def get_tensor_board(self):
        return TensorBoard(log_dir='./logs',
                histogram_freq=0,
                write_graph=True,
                write_images=True)
    
    def fit(self,autoencoder, cp, tb):
        return autoencoder.fit(self._train_x, self._train_x,
                         epochs=self._nb_epoch,
                         batch_size=self._batch_size,
                         shuffle=True,
                         validation_data=(self._test_x,self._test_x),
                         verbose=1,
                         callbacks=[cp, tb])
            
        
    def store_history_for(self, model_file, autoencoder):
        history = autoencoder.history
        history_path = self._model_dir + model_file
        with open(history_path, 'wb') as history_file:
            pickle.dump(history, history_file)    
    
    def train(self, autoencoder, model_file, history_file):
        self.compile(autoencoder)
        cp = self.get_checkpoint_for(model_file)
        tb = self.get_tensor_board()
        autoencoder = self.fit(autoencoder, cp, tb)
        self.store_history_for(history_file, autoencoder)

class LinearTrainer(AbstractTrainer):
    def __init__(self, nb_epoch, batch_size, learning_rate, dataset_dir, model_dir):
        super().__init__(nb_epoch, batch_size, learning_rate, dataset_dir, model_dir)

    def train_autoencoder(self, number):
        input_dim = self._train_x.shape[1]

        input_layer = Input(shape=(input_dim, ))
        method_to_call = getattr(super(), 'train_autoencoder_'+str(number))
        hidden_layer = method_to_call(input_dim, input_layer)

        decoder = Dense(input_dim, activation='relu')(hidden_layer)

        autoencoder = Model(inputs=input_layer, outputs=decoder)
        super().train(autoencoder, "model" + str(number) + ".h5","model" + str(number) + ".history")

class SmellsTrainer(AbstractTrainer):
    def __init__(self, nb_epoch, batch_size, learning_rate, dataset_dir, model_dir):
        super().__init__(nb_epoch, batch_size, learning_rate, dataset_dir, model_dir)

    def train_autoencoder(self, number):
        input_dim = self._train_x.shape[1]

        input_layer = Input(shape=(input_dim, ))
        method_to_call = getattr(super(), 'train_autoencoder_'+str(number))
        hidden_layer = method_to_call(input_dim, input_layer)

        decoder = Dense(input_dim, activation='sigmoid')(hidden_layer)

        autoencoder = Model(inputs=input_layer, outputs=decoder)
        super().train(autoencoder, "model" + str(number) + ".h5","model" + str(number) + ".history")


import pandas as pd
import numpy as np
from keras.models import load_model
from sklearn.metrics import roc_curve, roc_auc_score, auc, precision_recall_curve, average_precision_score
import os
import pickle
from scipy.special import softmax
from prg import prg

class MetricsGenerator(object):
    def __init__(self, dataset_dir, model_dir, metrics_dir):
        self._model_dir = model_dir
        self._metrics_dir = metrics_dir
        self._train_x = pd.read_csv(dataset_dir + "train_x.csv")
        self._test_x = pd.read_csv(dataset_dir + "test_x.csv")
        self._train_x = self._train_x.drop(self._train_x.columns[0], axis=1)
        self._test_x = self._test_x.drop(self._test_x.columns[0], axis=1)
        self._train_y = pd.read_csv(dataset_dir + "train_y.csv")
        self._test_y = pd.read_csv(dataset_dir + "test_y.csv")


    def generate_metrics_for_model(self, model):
        error_df = self.get_error_df(model) 
        roc_df, roc_auc_df = self.get_roc_and_auc_df(error_df)
        precision_recall_df, precision_recall_auc_df, average_precision_score_df = self.get_precision_recall_and_auc_df(error_df)
        prg_df, prg_auc_df = self.get_prg_and_auc_df(error_df)
        history_df = self.get_history_df(model)
        self.create(self._metrics_dir + "model" + str(model))
        self.store_df("error_df", model,error_df)
        self.store_df("roc_df", model, roc_df)
        self.store_df("roc_auc_df", model, roc_auc_df)
        self.store_df("precision_recall_df", model, precision_recall_df)
        self.store_df("precision_recall_auc_df", model, precision_recall_auc_df)
        self.store_df("average_precision_score_df", model, average_precision_score_df)
        self.store_df("prg_df", model, prg_df)
        self.store_df("prg_auc_df", model, prg_auc_df)
        self.store_df("history_df", model, history_df)
                
    def get_error_df(self, model):
        model = load_model(self._model_dir + "model" + str(model) + ".h5")
        test_x_predicted = model.predict(self._test_x)
        mse = np.mean(np.power(self._test_x - test_x_predicted, 2), axis = 1)
        error_df = pd.DataFrame({'Reconstruction_error':mse, 'True_values': self._test_y['target']})
        return error_df
    def get_roc_and_auc_df(self, error_df):
        false_pos_rate, true_pos_rate, thresholds = roc_curve(error_df.True_values, error_df.Reconstruction_error)
        i = np.arange(len(true_pos_rate))
        roc_df = pd.DataFrame({'FPR': pd.Series(false_pos_rate, index=i), 'TPR': pd.Series(true_pos_rate, index=i), 'Threshold': pd.Series(thresholds, index=i)})

        roc_auc = roc_auc_score(error_df.True_values, error_df.Reconstruction_error)
        i = np.arange(1)
        roc_auc_df = pd.DataFrame({'AUC': pd.Series(roc_auc, index=i)})
        return roc_df, roc_auc_df

    def get_precision_recall_and_auc_df(self, error_df):

        precision, recall, thresholds = precision_recall_curve(error_df.True_values, error_df['Reconstruction_error'])
        
        precision = precision[:-1]
        recall = recall[:-1]
        i = np.arange(len(precision))
        precision_recall_df = pd.DataFrame({'Precision': pd.Series(precision, index=i), 'Recall':pd.Series(recall, index=i), 'Threshold':pd.Series(thresholds, index=i)})

        
        i = np.arange(1)
        precision_recall_auc = auc(recall, precision)

        precision_recall_auc_df = pd.DataFrame({'AUC': pd.Series(precision_recall_auc, index=i)})

        average_precision = average_precision_score(error_df.True_values, error_df.Reconstruction_error)

        average_precision_score_df = pd.DataFrame({'AP': pd.Series(average_precision, index=i)})
        return precision_recall_df, precision_recall_auc_df, average_precision_score_df

    def get_prg_and_auc_df(self, error_df):
        prg_curve = prg.create_prg_curve(error_df.True_values, error_df.Reconstruction_error)
        prg_curve_df = pd.DataFrame.from_dict(prg_curve)
        

        i = np.arange(1)
        prg_auc = prg.calc_auprg(prg_curve)
        prg_auc_df = pd.DataFrame({'AUC': pd.Series(prg_auc, index=i)})

        return prg_curve_df, prg_auc_df

       
    def store_df(self, filename, model, df):
        df.to_csv(self._metrics_dir + "model"+str(model) + "/" + filename + ".csv")

    def create(self, directory):
        if not os.path.exists(directory):
            os.makedirs(directory)

    def get_history_df(self, model):
        with (open(self._model_dir + "model" + str(model) + ".history", 'rb')) as history_file:
            history = pickle.load(history_file)
        i = np.arange(len(history['loss']))
        return pd.DataFrame({'val_loss':pd.Series(history['val_loss'], index=i),'val_acc':pd.Series(history['val_acc'], index=i), 'loss':pd.Series(history['loss'], index=i), 'acc':pd.Series(history['acc'], index=i)})
    


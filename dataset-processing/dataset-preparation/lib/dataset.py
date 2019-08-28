import sys
sys.path.insert(0, '../../lib/util')
import constants
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import StratifiedShuffleSplit


class AbstractDataset(object):  
    def __init__(self, dataset):
        train_x, test_x, train_y, test_y = self.stratify_data(dataset)
        self._train_x = train_x
        self._test_x = test_x
        self._train_y = train_y
        self._test_y = test_y

    def stratify_data(self, dataset): 
        split = StratifiedShuffleSplit(n_splits=1, test_size=0.2, random_state=42)
        for train_index, test_index in split.split(dataset, dataset['target']):
            strat_train_set = dataset.iloc[train_index]
            strat_test_set = dataset.iloc[test_index]
        
        strat_train_set = strat_train_set[strat_train_set.target == 0]
        train_x = strat_train_set.loc[:, strat_train_set.columns != 'target']
        train_y = strat_train_set[['target']]
        test_x = strat_test_set.loc[:, strat_test_set.columns != 'target']
        test_y = strat_test_set[['target']]
        return train_x, test_x, train_y, test_y

    def get_train_x(self):
        return self._train_x

    def get_train_y(self): 
        return self._train_y

    def get_test_x(self): 
        return self._test_x

    def get_test_y(self):
        return self._test_y

   
class MetricsOnlyDataset(AbstractDataset):
    def __init__(self, dataset_path):
        dataset = pd.read_csv(dataset_path, names=constants.HEADER_METRICS)
        dataset = self.scale_data(dataset)
        super().__init__(dataset)  

    def scale_data(self, dataset):
       dataset['loc'] = StandardScaler().fit_transform(dataset['loc'].values.reshape(-1,1)) 
       dataset['nof'] = StandardScaler().fit_transform(dataset['nof'].values.reshape(-1,1)) 
       dataset['nopf'] = StandardScaler().fit_transform(dataset['nopf'].values.reshape(-1,1)) 
       dataset['nom'] = StandardScaler().fit_transform(dataset['nom'].values.reshape(-1,1)) 
       dataset['nopm'] = StandardScaler().fit_transform(dataset['nopm'].values.reshape(-1,1)) 
       dataset['wmc'] = StandardScaler().fit_transform(dataset['wmc'].values.reshape(-1,1)) 
       dataset['nc'] = StandardScaler().fit_transform(dataset['nc'].values.reshape(-1,1)) 
       dataset['dit'] = StandardScaler().fit_transform(dataset['dit'].values.reshape(-1,1)) 
       dataset['lcom'] = StandardScaler().fit_transform(dataset['lcom'].values.reshape(-1,1)) 
       dataset['fanin'] = StandardScaler().fit_transform(dataset['fanin'].values.reshape(-1,1)) 
       dataset['fanout'] = StandardScaler().fit_transform(dataset['fanout'].values.reshape(-1,1)) 
       return dataset

class MetricsAndSmellsDataset(AbstractDataset):
    def __init__(self, dataset_path):
        dataset = pd.read_csv(dataset_path, names=constants.HEADER_SMELLS_METRICS)
        dataset = self.scale_data(dataset)
        super().__init__(dataset) 

    def scale_data(self, dataset):
       dataset['loc'] = StandardScaler().fit_transform(dataset['loc'].values.reshape(-1,1)) 
       dataset['nof'] = StandardScaler().fit_transform(dataset['nof'].values.reshape(-1,1)) 
       dataset['nopf'] = StandardScaler().fit_transform(dataset['nopf'].values.reshape(-1,1)) 
       dataset['nom'] = StandardScaler().fit_transform(dataset['nom'].values.reshape(-1,1)) 
       dataset['nopm'] = StandardScaler().fit_transform(dataset['nopm'].values.reshape(-1,1)) 
       dataset['wmc'] = StandardScaler().fit_transform(dataset['wmc'].values.reshape(-1,1)) 
       dataset['nc'] = StandardScaler().fit_transform(dataset['nc'].values.reshape(-1,1)) 
       dataset['dit'] = StandardScaler().fit_transform(dataset['dit'].values.reshape(-1,1)) 
       dataset['lcom'] = StandardScaler().fit_transform(dataset['lcom'].values.reshape(-1,1)) 
       dataset['fanin'] = StandardScaler().fit_transform(dataset['fanin'].values.reshape(-1,1)) 
       dataset['fanout'] = StandardScaler().fit_transform(dataset['fanout'].values.reshape(-1,1)) 
       return dataset

class SmellsOnlyDataset(AbstractDataset):
    def __init__(self, dataset_path):
        dataset = pd.read_csv(dataset_path, names=constants.HEADER_SMELLS)
        super().__init__(dataset)
        

import argparse
import os
import sys
sys.path.insert(0, '../../lib/dataset')
from dataset import SmellsOnlyDataset, MetricsOnlyDataset, MetricsAndSmellsDataset

def create(directory): 
    if not os.path.exists(directory):
        os.makedirs(directory)

def check_type(value):
    ivalue = int(value)
    if ivalue < 0 or ivalue >= 3:
        raise argparse.ArgumentTypeError("%s is an invalid int value:\n 0 - type smells\n 1 - type metrics\n 2 - type smells and metrics" % value)
    return ivalue

def get_arguments():
    parser = argparse.ArgumentParser(description="Smell-based Defect Prediction. Process Dataset.")
    parser.add_argument('-t','--type', required = True, type = check_type, help="Type of dataset: 0 --- Metrics Only; 1 --- Smells Only; 2 --- Metrics and Smells.")
    parser.add_argument('-d','--dataset', required = True, help="Path to the dataset.")        
    return vars(parser.parse_args())

def main(out_dir):
    arguments = get_arguments()
    if(arguments['type'] == 0):
        dataset = MetricsOnlyDataset(arguments['dataset'])
        out_dir = out_dir + "metrics-only-dataset/"
    elif(arguments['type'] == 1):
        dataset = SmellsOnlyDataset(arguments['dataset'])
        out_dir = out_dir + "smells-only-dataset/"
    elif(arguments['type'] == 2):
        dataset = MetricsAndSmellsDataset(arguments['dataset'])
        out_dir = out_dir + "metrics-and-smells-dataset/"
    else:
        raise ValueError("The type must be either 0, 1 or 2")
    
    create(out_dir)
    print("Saving Train X")
    dataset.get_train_x().to_csv(out_dir + "train_x.csv")

    print("Saving Test X")
    dataset.get_test_x().to_csv(out_dir + "test_x.csv")
    
    print("Saving Train Y")
    dataset.get_train_y().to_csv(out_dir + "train_y.csv")


    print("Saving Tests Y")
    dataset.get_test_y().to_csv(out_dir + "test_y.csv")
   

if __name__ == '__main__':
    out_dir = "../out/"
    create(out_dir)
    main(out_dir)


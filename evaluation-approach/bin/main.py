import argparse
import os
import sys
sys.path.insert(0, '../../lib/metric')
from metric import MetricsGenerator

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
    return vars(parser.parse_args())

def main(out_dir):
    arguments = get_arguments()
    if(arguments['type'] == 0):
        dataset_dir = out_dir + "metrics-only-dataset/"
        model_dir = out_dir + "metrics-only-model/"
        metrics_dir = out_dir + "metrics-only-metrics/"

    elif(arguments['type'] == 1):
        dataset_dir = out_dir + "smells-only-dataset/"
        model_dir = out_dir + "smells-only-model/"
        metrics_dir = out_dir + "smells-only-metrics/"
    
    elif(arguments['type'] == 2):
        dataset_dir = out_dir + "metrics-and-smells-dataset/"
        model_dir = out_dir + "metrics-and-smells-model/"
        metrics_dir = out_dir + "metrics-and-smells-metrics/"

    metrics = MetricsGenerator(dataset_dir, model_dir, metrics_dir)
    for model in range(5):
        metrics.generate_metrics_for_model(model)

if __name__ == "__main__":
    out_dir = "../../../out/"
    create(out_dir)
    main(out_dir)


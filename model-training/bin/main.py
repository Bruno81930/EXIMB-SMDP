import argparse
import os
from multiprocessing import Pool
import sys
sys.path.insert(0, '../../lib/model')
from train import SmellsTrainer, LinearTrainer

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
    nb_epoch = 2
    batch_size = 128
    learning_rate = 1e-7
    if(arguments['type'] == 0):
        dataset_dir = out_dir + "metrics-only-dataset/"
        model_dir = out_dir + "metrics-only-model/"
        create(model_dir)
        trainer = LinearTrainer(nb_epoch, batch_size, learning_rate, dataset_dir, model_dir)

    elif(arguments['type'] == 1):
        dataset_dir = out_dir + "smells-only-dataset/"
        model_dir = out_dir + "smells-only-model/"
        create(model_dir)
        trainer = SmellsTrainer(nb_epoch, batch_size, learning_rate, dataset_dir, model_dir)

    elif(arguments['type'] == 2):
        dataset_dir = out_dir + "metrics-and-smells-dataset/"
        model_dir = out_dir + "metrics-and-smells-model/"
        create(model_dir)
        trainer = LinearTrainer(nb_epoch, batch_size, learning_rate, dataset_dir, model_dir)


    pool = Pool(processes=1)
    pool.map(trainer.train_autoencoder, range(5))


if __name__ == '__main__':
    out_dir = "../../../out/"
    if not os.path.exists(out_dir):
        raise RuntimeError('Run dataset task first.')

    main(out_dir)

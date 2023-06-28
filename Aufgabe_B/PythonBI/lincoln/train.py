
from typing import Tuple
from copy import deepcopy

import numpy as np
from numpy import ndarray

from lincoln.network import NeuralNetwork
from lincoln.optimizers import Optimizer
from lincoln.np_utils import permute_data


class Trainer(object):
    
    def __init__(self,
                 net: NeuralNetwork,
                 optim: Optimizer) -> None:
        """Trainer eines Neuronalen Netzes net mittels Optimierer optim 

        Args:
            net (NeuralNetwork): Neuronale Netz, das trainiert wird
            optim (Optimizer): Optimierer, der zum Training verwendet wird
        """
        self.net = net
        self.optim = optim
        self.best_loss = 1e9
        setattr(self.optim, 'net', self.net)

    def fit(self, X_train: ndarray, y_train: ndarray,
            X_val: ndarray, y_val: ndarray,
            epochs: int=100,
            eval_every: int=10,
            batch_size: int=32,
            seed: int = 1,
            single_output: bool = False,
            restart: bool = True,
            early_stopping: bool = True)-> None:
        """Anpassen der Gewichte (=Trainieren=Lernen) des Neuronalen Netzes net auf Basis der Traininingsdaten über eine Anzahl an Epochen -
        Alle eval_every-Epochen wird die Güte des Netzes für die Validierungsdaten ermittelt.
        
        Args:
            X_train (ndarray): Predictorvariablen (features) der Trainingsdaten
            y_train (ndarray): Zielvariablen (lables) der Trainingsdaten
            X_val (ndarray): Predictorvariablen (features) der Validierungsdaten
            y_val (ndarray):  Zielvariablen (lables) der Valdierungsdaten
            epochs (int, optional): Anzahl an Durchläufen durch die Trainingsdatensätze - Default ist 100.
            eval_every (int, optional): Anzahl an Epochen, nach denen jeweils die Modellgüte ausgewertet wird  - Default ist 10.
            batch_size (int, optional): Anzahl Datensätze, die in einem Trainingsschritt zum Anpassen der Gewichte verwendet werden - Default ist 32.
            seed (int, optional): Startwert für den Zufallstzahlengenerator  - Default ist 1.
            single_output (bool, optional): Einzelausgabe  - Default ist False.
            restart (bool, optional): Neubelegung der Gewichte  - Default ist True.
            early_stopping (bool, optional): Abbruch des Trainierens, falls Loss nicht mehr kleiner wird und Verwendung des letzten Modells laut evel_every,  - Default ist True.
        """
        setattr(self.optim, 'max_epochs', epochs)
        self.optim._setup_decay()

        np.random.seed(seed)
        if restart:
            for layer in self.net.layers:
                layer.first = True

            self.best_loss = 1e9

        for e in range(epochs):

            if (e+1) % eval_every == 0:

                last_model = deepcopy(self.net)

            X_train, y_train = permute_data(X_train, y_train)

            batch_generator = self.generate_batches(X_train, y_train,
                                                    batch_size)

            for ii, (X_batch, y_batch) in enumerate(batch_generator):

                self.net.train_batch(X_batch, y_batch)

                self.optim.step()

            if (e+1) % eval_every == 0:

                test_preds = self.net.forward(X_val)
                loss = self.net.loss.forward(test_preds, y_val)

                if early_stopping:
                    if loss < self.best_loss:
                        print(f"Validation loss after {e+1} epochs is {loss:.3f}")
                        self.best_loss = loss
                    else:
                        print()
                        print(f"Loss increased after epoch {e+1}, final loss was {self.best_loss:.3f},",
                              f"\nusing the model from epoch {e+1-eval_every}")
                        self.net = last_model
                        # ensure self.optim is still updating self.net
                        setattr(self.optim, 'net', self.net)
                        break
                else:
                    print(f"Validation loss after {e+1} epochs is {loss:.3f}")
            
            # wenn Optipn gewählt, Lernrate anpassen
            if self.optim.final_lr:
                self.optim._decay_lr()


    def generate_batches(self,
                         X: ndarray,
                         y: ndarray,
                         size: int = 32) -> Tuple[ndarray]:

        assert X.shape[0] == y.shape[0], \
        '''
        features and target must have the same number of rows, instead
        features has {0} and target has {1}
        '''.format(X.shape[0], y.shape[0])

        N = X.shape[0]

        for ii in range(0, N, size):
            X_batch, y_batch = X[ii:ii+size], y[ii:ii+size]

            yield X_batch, y_batch

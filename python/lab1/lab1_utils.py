import numpy as np
import matplotlib.pyplot as plt
from sklearn import datasets



def _gen_linear_data(n_samples, noise_level):
    fst_half = n_samples // 2
    snd_half = n_samples - fst_half

    Y = np.ones((n_samples, ))
    Y[:fst_half] = -1

    X1 = np.random.normal([5, 5], scale=[1*noise_level], size=(fst_half, 2))
    X2 = np.random.normal([8, 5], scale=[1*noise_level], size=(snd_half, 2))

    return np.concatenate((X1, X2), 0), Y

def _gen_moons(n_samples, noise_level):
    X, Y = datasets.make_moons(n_samples=n_samples, shuffle=True, noise=noise_level)
    Y[Y == 0] = -1

    return X, Y

def _gen_circles(n_samples, noise_level):
    X, Y = datasets.make_circles(n_samples=n_samples, shuffle=True, noise=noise_level)
    Y[Y == 0] = -1
    return X, Y

def create_random_data(n_samples, noise_level, dataset="linear", seed=0):
    """Generates a random dataset. Can generate 'linear', 'moons' or 'circles'.

    Parameters
    ----------
    n_samples
        The total number of samples. These will be equally divided between positive
        and negative samples.
    noise_level
        The amount of noise: higher noise -> harder problem. The meaning of the noise
        is different for each dataset.
    dataset
        A string to specify the desired dataset. Can be 'linear', 'moons', 'circles'.
    seed
        Random seed for reproducibility.

    Returns
    -------
    X
        A 2D array of features
    Y
        A vector of targets (-1 or 1)
    """
    np.random.seed(seed)

    if dataset.lower() == "linear":
        return _gen_linear_data(n_samples, noise_level)
    elif dataset.lower() == "moons":
        return _gen_moons(n_samples, noise_level)
    elif dataset.lower() == "circles":
        return _gen_circles(n_samples, noise_level)
    else:
        raise ValueError(("Dataset '%s' is not valid. Valid datasets are:"
                          " 'linear', 'moons', 'circles'") % (dataset))


def data_split(X, Y, n_train):
    assert n_train < X.shape[0]
    idx = np.arange(X.shape[0])
    np.random.shuffle(idx)
    return X[idx[:n_train], :], X[idx[n_train:], :], Y[idx[:n_train]], Y[idx[n_train:]]


def plot_dataset(X, y):
    fig, ax = plt.subplots()
    ax.scatter(X[y == -1][:,0], X[y == -1][:,1], alpha=0.5)
    ax.scatter(X[y == 1][:,0], X[y == 1][:,1], alpha=0.5)

def plot_separation(X, Y, model):
    # Plot the decision boundary. For that, we will assign a color to each
    # point in the mesh [x_min, x_max]x[y_min, y_max].
    x_min, x_max = X[:, 0].min() - .5, X[:, 0].max() + .5
    y_min, y_max = X[:, 1].min() - .5, X[:, 1].max() + .5
    h = .02  # step size in the mesh
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
    Z = model.predict(np.c_[xx.ravel(), yy.ravel()])
    Z[Z < 0] = -1
    Z[Z >= 0] = 1

    Z = Z.reshape(xx.shape)
    plt.contour(xx, yy, Z, cmap=plt.cm.Paired)

    plt.scatter(X[Y == -1][:, 0], X[Y == -1][:, 1])
    plt.scatter(X[Y == 1][:, 0], X[Y == 1][:, 1])

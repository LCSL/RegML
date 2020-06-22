import numpy as np

def create_random_data(n_samples, noise_level, seed=0):
    np.random.seed(seed)

    fst_half = n_samples // 2
    snd_half = n_samples - fst_half

    Y = np.ones((n_samples, ))
    Y[:fst_half] = -1

    X1 = np.random.normal([5, 5], scale=[1*noise_level], size=(fst_half, 2))
    X2 = np.random.normal([8, 5], scale=[1*noise_level], size=(snd_half, 2))

    return np.concatenate((X1, X2), 0), Y


    # # b: bias of the separating line
    # b = 0#np.random.random() / 2
    # # m: slope of the separating line
    # m = 1#np.random.random() * 2 + 0.01

    # Y = np.ones((n_samples, ))
    # X = []
    # while len(X) < n_samples // 2:
    #     x = np.random.random()
    #     y = np.random.random()
    #     fy = x*m + b
    #     if y <= fy:
    #         X.append((x + np.random.random()*noise_level, y + np.random.random()*noise_level))
    # Y[:len(X)] = -1


    # while len(X) < n_samples:
    #     x = np.random.random()
    #     y = np.random.random()
    #     fy = x*m + b
    #     if y > fy:
    #         X.append((x + np.random.random()*noise_level, y + np.random.random()*noise_level))

    # X = np.array(X)

    # return X, Y


def data_split(X, Y, n_train):
    assert n_train < X.shape[0]
    idx = np.arange(X.shape[0])
    np.random.shuffle(idx)
    return X[idx[:n_train], :], X[idx[n_train:], :], Y[idx[:n_train]], Y[idx[n_train:]]


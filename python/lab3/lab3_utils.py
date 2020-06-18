import numpy as np

from numpy.linalg import norm


def create_random_data(n_samples, n_features, s, noise_level, seed=0):
    """Generate a random dataset for regression, according to:
    y_i = w^\top x_i + epsilon_i
    where w has `s` non zero entries, x_i's are i.i.d. Gaussian 
    with identity as covariance, and epsilon_i are i.i.d standard
    Gaussian, with variance controlled by noise_level.
    
    Parameters
    ----------
    n_samples: int
        The number of samples.
    n_features: int
        The number of features.
    s: int
        Sparsity (number of non-zero entries) of w.
    noise_level: float
        Importance of noise. ||epsilon|| / ||X @ w|| = noise_level
    seed: int, optional (default=0)
        Seed for pseudo-random number generation.
    
    Returns
    -------
    X: np.array, shape (n_samples, n_features)
        Design matrix.
    y: np.array, shape (n_samples,)
        Observation vector.
    """
    if s > n_features:
        raise ValueError("Sparsity s cannot be larger than "
                         "n_features, got %s > %s" % 
                         (s, n_features))
    np.random.seed(0)  # seed to always get same data
    X = np.random.randn(n_samples, n_features)
    w = np.zeros(n_features)
    support = np.random.choice(n_features, s, replace=False)
    w[support] = np.random.randn(s)
    epsilon = np.random.randn(n_samples)
    
    y = X @ w / norm(X @ w) + noise_level * epsilon / norm(epsilon)
    return X, y


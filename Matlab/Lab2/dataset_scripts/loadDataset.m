function [X, Y, Xt, Yt] = loadDataset(simulation_name,n, nt, p)


    if (isnan(n) || isnan(nt))

        error('You must enter a numeric value for number of samples ');
    end
    if (isnan(p) || p < 0 || p > 1)
        error('You must enter a numeric value in the range [0, 1] for the amount of noise');
    end

% 'MOONS' 'GAUSSIANS' 'LINEAR' 'SINUSOIDAL' 'SPIRAL'
    switch simulation_name
        case 'Toy'
            [X, Y, Xt, Yt]=toy_data(n,nt,p,1);
        case 'Moons'
            [X, Y] = create_dataset(n, 'MOONS', p, 'PRESET');
            [Xt, Yt] = create_dataset(nt, 'MOONS', p, 'PRESET');
        case 'Gaussians'
            [X, Y] = create_dataset(n, 'GAUSSIANS', p, 'PRESET');
            [Xt, Yt] = create_dataset(nt, 'GAUSSIANS', p, 'PRESET');
        case 'Linear'
            [X, Y] = create_dataset(n, 'LINEAR', p, 'PRESET');
            [Xt, Yt] = create_dataset(nt, 'LINEAR', p, 'PRESET');
        case 'Sinusoidal'
            [X, Y] = create_dataset(n, 'SINUSOIDAL', p, 'PRESET');
            [Xt, Yt] = create_dataset(nt, 'SINUSOIDAL', p, 'PRESET');
        case 'Spiral'
            [X, Y] = create_dataset(n, 'SPIRAL', p, 'PRESET');
            [Xt, Yt] = create_dataset(nt, 'SPIRAL', p, 'PRESET');

    end
end

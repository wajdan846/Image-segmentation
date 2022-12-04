function segmented_image = two_phase(image, sigma, K, iterations)
  % Convert the image to double precision
  image = double(image);

  % Initialize the level set function with two circles
  [x, y] = meshgrid(1:size(image, 2), 1:size(image, 1));
  phi = sqrt((x - size(image, 2)/2).^2 + (y - size(image, 1)/2).^2) - 60;
  phi = phi - sqrt((x - size(image, 2)/4).^2 + (y - size(image, 1)/4).^2) + 30;

  % Perform the evolution
  for i = 1:iterations
    phi = drlse_edge(phi, gd(phi, K) + K.*image, sigma, K);
  end

  % Get the final segmented image
  segmented_image = image;
  segmented_image(phi > 0) = 255;
end

function g = gd(f, kappa)
  % Get the gradient of the level set function
  [fx, fy] = gradient(f);
  g = 1./sqrt(fx.^2 + fy.^2 + 1).*(fx.^2 + fy.^2 - kappa^2);
end

function u = drlse_edge(phi, g, lambda, mu)
  % Solve the partial differential equation
  [phi_x, phi_y] = gradient(phi);
  s = sqrt(phi_x.^2 + phi_y.^2);
  smallNumber = 1e-10;
  Nx = phi_x ./ (s + smallNumber);
  Ny = phi_y ./ (s + smallNumber);
  curvature = div(Nx, Ny);
  diracPhi = Dirac(phi, 5);
  areaTerm = diracPhi .* g;
  edgeTerm = (lambda .* diracPhi .* g) + (mu .* curvature .* diracPhi);
  u = phi + areaTerm + edgeTerm;
end

function f = div(nx, ny)
  % Compute the divergence of a vector field
  [nxx, junk] = gradient(nx);
  [junk, nyy] = gradient(ny);
  f = nxx + nyy;
end

function f = Dirac(x, sigma)
  % Compute the Dirac function
  f = (1/2/sigma) * (1 + cos(pi*x/sigma));
  b = (x <= sigma) & (x >= -sigma);
  f = f.*b;
end

function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%

temp  = X*Theta' - Y;
J = sum(sum(temp.^2.*R))/2 + (sum(sum(Theta.^2)) + sum(sum(X.^2))) *(lambda/2);

for k = 1: size(X,2)
    for i = 1: size(X,1)
      for j = 1: size(Theta, 1)
          if R(i,j) == 1
            thetat = Theta(j,:)';
            X_grad(i, k) = X_grad(i, k) + (X(i, :)*thetat - Y(i,j))*Theta(j,k);
          end
      end;
       X_grad(i, k) =  X_grad(i, k) + lambda*X(i,k);
    end;
end;

for k = 1: size(Theta,2)
    for j = 1: size(Theta,1)
      for i = 1: size(X, 1)
          if R(i,j) == 1
            xt = X(i,:)';
            Theta_grad(j, k) = Theta_grad(j, k) + (Theta(j, :)*xt - Y(i,j))*X(i,k);
          end
      end;
      Theta_grad(j,k) = Theta_grad(j,k) + lambda*Theta(j,k);
    end;
end;










% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end

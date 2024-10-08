function Xlags=lagmatrix(X,lags)

[T,N] = size(X);

Xlags = NaN(T,N*length(lags));
for ind = 1:length(lags)
    Xlags((1+lags(ind)):end,N*(ind-1)+(1:N)) = X(1:end-lags(ind),:);
end

end
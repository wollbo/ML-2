function gaussK = gaussK(x1,x2,sigma)

gaussK = exp(-norm((x1-x2)/(2*sigma^2),2));
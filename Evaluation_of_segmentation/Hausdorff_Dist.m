function HD = Hausdorff_Dist(A, B)
%%
% Výpočet Hausdorfovy vzdálenosti masek A a B
%%
A = logical(A);
B = logical(B);

if size(A,3)==1
    kernel = create_sphere(1);
    kernel = kernel(:,:,ceil(size(kernel,3)/2));
else
    kernel = create_sphere(1);
end

A_ctr = A - imerode(A,kernel);
distA = bwdist(logical(A_ctr));

B_ctr = B - imerode(B,kernel);
distB = bwdist(logical(B_ctr));

HD = max( mean(distA(logical(B_ctr))), mean(distB(logical(A_ctr))) );

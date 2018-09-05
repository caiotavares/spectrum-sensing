function s = sumstructs(s1, s2)
%
% sumstructs - Sum two structs with same fields.
%
% s = sumstructs(s1,s2)

fields1 = fieldnames(s1);
fields2 = fieldnames(s2);

if (length(fields1) ~= length(fields2))
    error('Structs have different fields');
end

s = s1;

for i=1:length(fields1)
    field = fields1(i);
    val1 = s1.(field{:});
    val2 = s2.(field{:});
    
    if (length(val1) ~= length(val2))
       error('Fields have different dimensions')
    end
    
    s.(field{:}) = val1 + val2;
end

function [valide, t] = SolveQuadratic(A, B, C)
    if (A < 0.0001)
        if (B < 0.0001)
            valide = false;
            t = 0;
        else
            valide = true;
            t = -B / A;
            if (t < 0)
                valide = false;
            end
        end
    else
        discriminant = B * B - 4 * A * C;
        if (discriminant < 0)
            valide = false;
            t = 0;
        else
            valide = true;
            t = 0;
            t_1 = (-B - sqrt(discriminant)) / (2 * A);
            t_2 = (-B + sqrt(discriminant)) / (2 * A);
            if (t_1 < 0 && t_2 < 0)
                valide = false;
            elseif (t_1 > 0 && t_2 < 0)
                t = t_1;
            elseif (t_1 < 0 && t_2 > 0)
                t = t_2;
            elseif (t_1 > 0 && t_2 > 0)
                if (t_1 < t_2)
                    t = t_1;
                else
                    t = t_2;
                end
            end
        end
    end
end

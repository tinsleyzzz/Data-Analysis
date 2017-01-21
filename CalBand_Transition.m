% OBJECTIVE:
% The University of California Marching Band performs at halftime during all home football games as well as 
% some away games and bowl games. As part of the performance, the band forms several formations on the field 
% while marching and playing music. Currently, the band members need to spend a lot of time during rehearsals
% practicing the formations as well as the transitions from one formation to the next without collide during  
% the transitions. We want to write a program that can coordinate a transition strategy between one formation 
% and the next for Cal Marching Band. Automating transition process will not only save their time, but also 
% enable them to form more complicated formations.

function [instructions] = calband_transition(initial_formation, target_formation, max_beats)
% This code finds the i and j indices of each target location and stores
% them in i and j, respectively (note that i and j are not used as of yet!)
% Finds the number of bandmembers by adding up all the 1s in the target
% Makes a structure with the appropriate fields (without any actual data)
% and copies it nb times to get a 1 x nb array of structs
% for h = 1:n_bandmembers

n_bandmembers = sum(sum(target_formation));

[tx, ty] = find(target_formation); %find the position of points in target formation
ix = zeros(1, n_bandmembers); % setting x axis for initial locations
iy = zeros(1, n_bandmembers); % setting y axis for initial locations
for g = 1: n_bandmembers
    [m, n] = find(initial_formation == g); % finding the locations in the initial formation
    ix(g) = m;
    iy(g) = n;
end

direction = {};
route = {};
D = {};


i_target = zeros(1, n_bandmembers); % setting i_target 
j_target = zeros(1, n_bandmembers); % setting j_target
wait = zeros(1, n_bandmembers); % setting wait for each marcher

for a = 1:n_bandmembers
       distance = []; % setting distance
    for c = 1:n_bandmembers 
        distance = [distance, abs(ix(a)-tx(c))+abs(iy(a)-ty(c))]; % calculating Manhattan distance to find the closest distance
    end
    
    if min(distance) == 0 % if minimum distance is 0 it means that the marcher does not move during the movement
        y1 = find(distance == 0, 1); % if the same minimum distance is more than 1, we choose the first one
        i_target(a) = tx(y1); % setting the row index of the target locations for aeach march
        j_target(a) = ty(y1); % setting the column index of target locations for each marcher
        wait(a) = max_beats; % the marcher doesn't need to move
        direction{end+1} = '.'; 
        tx(y1) = NaN; % remove the original coordinates to make sure points won'e be selected repeatedly
        ty(y1) = NaN;
        instructions(a) = struct('i_target',i_target(a),'j_target',j_target(a),'wait', wait(a),'direction',direction{a});
        continue
    end
              
    y1 = find(distance == min(distance),1); %find minmum distance
    xdis = tx(y1)-ix(a); % find related initial point
    ydis = ty(y1)-iy(a); 
    
    if xdis == 0 && ydis == 0
        wait(a) = max_beats; % the marcher doesn't need to move
        direction{end+1} = '.';
        i_target(a) = tx(y1); % for each marcher, record tx, ty in i_target, j_target
        j_target(a) = ty(y1);
        instructions(a) = struct('i_target',i_target(a),'j_target',j_target(a),'wait', wait(a),'direction',direction{a});

        continue % move on to the next loop: a = a + 1
    elseif xdis > 0 && ydis > 0 % decide the direction
        direction{end+1} = 'NE';
    elseif xdis > 0 && ydis == 0
        direction{end+1} = 'E';
    elseif xdis > 0 && ydis < 0
        direction{end+1} = 'SE';
    elseif xdis == 0 && ydis > 0
        direction{end+1} = 'N';
    elseif xdis == 0 && ydis < 0
        direction{end+1} = 'S';
    elseif xdis < 0 && ydis > 0
        direction{end+1} = 'NW';
    elseif xdis < 0 && ydis == 0
        direction{end+1} = 'W';
    else
        direction{end+1} = 'SW';
    end
    
    distance = abs(xdis) + abs(ydis);
    ypred = ty(y1);
    xpred = tx(y1);
    for n = 1:distance
        if ypred ~= iy(a)
            ypred = ypred + 1;
        elseif xpred ~= ix(a)
            xpred = xpred+1;
        end
        position = [xpred,ypred];
        route{a}(n,:) = position; % predict a route for each marcher
        for m = distance + 1: max_beats
            route{a}(m,:) = [NaN, NaN]; % to make the size of route for each marcher equal  
        end
    end
        
     i_target(a) = tx(y1); % for each marcher, record tx, ty in i_target, j_target
     j_target(a) = ty(y1);
     tx(y1) = NaN;
     ty(y1) = NaN;
     instructions(a) = struct('i_target',i_target(a),'j_target',j_target(a),'wait', wait(a),'direction',direction{a});
     
end

   
end  % end of the function             


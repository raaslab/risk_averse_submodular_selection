function graph_plot(greset_full,allnodes, r_nodes, goalroutes)
        currentroutes = cell(1, length(greset_full));
        cnt_r = 1; 
        for d = 1 : length(greset_full)
            for r = 1 : length(greset_full{d})
                % d_node: d_nodes_temp(i,1)
                % r_node: r_nodes_temp(cvar_greset{d}(r), 2)
                r_node_inx = find(allnodes==r_nodes(greset_full{d}(r)));
                currentroutes{cnt_r} = goalroutes{d, r_node_inx}; 
                cnt_r = cnt_r + 1;
            end
        end
%         length(currentroutes)
        
        currentroute1 = currentroutes{1}; 
        currentroute2 = currentroutes{2};
        currentroute3 = currentroutes{3};
%         currentroute4 = currentroutes{4};
%         currentroute5 = currentroutes{5};
%         currentroute6 = currentroutes{6};
%         currentroute7 = currentroutes{7};
%         currentroute8 = currentroutes{8};
%         currentroute9 = currentroutes{9};
%         currentroute10 = currentroutes{10};
%         currentroute11 = currentroutes{11};
%         currentroute12 = currentroutes{12};
        
        currentroute1_py = sprintf('%.0f,' , currentroute1);
        currentroute1_py = currentroute1_py(1:end-1);% strip final comma       
        currentroute2_py = sprintf('%.0f,' , currentroute2);
        currentroute2_py = currentroute2_py(1:end-1);% strip final comma
        currentroute3_py = sprintf('%.0f,' , currentroute3);
        currentroute3_py = currentroute3_py(1:end-1);% strip final comma
%         currentroute4_py = sprintf('%.0f,' , currentroute4);
%         currentroute4_py = currentroute4_py(1:end-1);% strip final comma
%         currentroute5_py = sprintf('%.0f,' , currentroute5);
%         currentroute5_py = currentroute5_py(1:end-1);% strip final comma
%         currentroute6_py = sprintf('%.0f,' , currentroute6);
%         currentroute6_py = currentroute6_py(1:end-1);% strip final comma
%         currentroute7_py = sprintf('%.0f,' , currentroute7);
%         currentroute7_py = currentroute7_py(1:end-1);% strip final comma
%         currentroute8_py = sprintf('%.0f,' , currentroute8);
%         currentroute8_py = currentroute8_py(1:end-1);% strip final comma
%         currentroute9_py = sprintf('%.0f,' , currentroute9);
%         currentroute9_py = currentroute9_py(1:end-1);% strip final comma
%         currentroute10_py = sprintf('%.0f,' , currentroute10);
%         currentroute10_py = currentroute10_py(1:end-1);% strip final comma
%         currentroute11_py = sprintf('%.0f,' , currentroute11);
%         currentroute11_py = currentroute11_py(1:end-1);% strip final comma
%         currentroute12_py = sprintf('%.0f,' , currentroute12);
%         currentroute12_py = currentroute12_py(1:end-1);% strip final comma
        % input to python script
        system(['/usr/local/opt/python3/bin/python3 plot_online_assign.py -r1 ' ...
            currentroute1_py ' -r2 ' currentroute2_py ' -r3 ' currentroute3_py]); 
        %
%                 system(['/usr/local/opt/python3/bin/python3 plot_online_assign.py -r1 ' ...
%             currentroute1_py ' -r2 ' currentroute2_py ' -r3 ' currentroute3_py ...
%             ' -r4 ' currentroute4_py ' -r5 ' currentroute5_py ' -r6 ' currentroute6_py...
%              ' -r7 ' currentroute7_py ' -r8 ' currentroute8_py ' -r9 ' currentroute9_py...
%              ' -r10 ' currentroute10_py ' -r11 ' currentroute11_py ' -r12 ' currentroute12_py]); 
end
life_soft = 5700;%软部件寿命
life_hard = 93000;%硬部件寿命
lamda_soft = 1/life_soft;
lamda_hard = 1/life_hard;
time_repair = 9.5;%修理时间期望
lamda_repair = 1/time_repair;
time_restart = 1;
lamda_restart = 1/time_restart;

samples = 100;%仿真次数
record = zeros(samples,6);%数据记录矩阵
avail = zeros(samples,9);

prb_hard = 1 - exp(-lamda_hard);%硬部件状态转移概率
prb_soft = 1 - exp(-lamda_soft);%软部件状态转移概率
prb_repair = 1 - exp(-lamda_repair);%修理状态转移概率
prb_restart = 1 - exp(-lamda_restart);
tic;

for m = 1:samples
	time_record = zeros(1,6);
	
	soft_state = zeros(5,1);
	hard_state = zeros(5,41);
	inter_state = zeros(5,19);
	col_state = zeros(1,11);
	
	sys_state = zeros(1,6);
	fail_flag_old = 0;
	fail_flag_new = 0;
	srs_fail_flag_old = 0;
	srs_fail_flag_new = 0;
	stk_flag = zeros(5,19);
	
	time_flag = 0;
	
	for life = 1:87600
		for i = 1:5
			if (soft_state(i,1) == 0)
				if (rand(1) < prb_soft)
					soft_state(i,1) = 1;
					%time_record(1) = time_record(1) + 1;
				%else soft_state(i,1) = 0;
				end
			else
				if (rand(1) < 0.982)
					if (rand(1) < prb_restart)
						soft_state(i,1) = 0;
					else soft_state(i,1) = 1;
					end
				else
					if (rand(1) < prb_repair)
						soft_state(i,1) = 0;
						time_record(1) = time_record(1) + 1;
					else soft_state(i,1) = 1;
					end
				end
			end
		end
			
		for i = 1:5
			for j = 1:41
				if (hard_state(i,j) == 0)
					if (rand(1) < prb_hard)
						hard_state(i,j) = 1;
						time_record(1) = time_record(1) + 1;
					%else hard_state(i,j) = 0;
					end
				else
					if (rand(1) < prb_repair)
						hard_state(i,j) = 0;
					%else hard_state(i,j) = 1;
					end
				end
			end
		end
			
		for i = 1:5
			for j = 1:19
				if (inter_state(i,j) == 0)
					if (rand(1) < prb_hard)
						inter_state(i,j) = 1;
						time_record(1) = time_record(1) + 1;
						if (rand(1)<0.35)
							stk_flag(i,j) = 1;
						else stk_flag(i,j) = 0;
						end
					else
						%inter_state(i,j) = 0;
						stk_flag(i,j) = 0;
					end
				else
					if (rand(1) < prb_repair)
						inter_state(i,j) = 0;
						stk_flag(i,j) = 0;
					%else inter_state(i,j) = 1;
					end
				end
			end
		end			
						
		for i = 1:11
			if (col_state(i) == 0)
				if (rand(1) < prb_hard)
					col_state(i) = 1;
					time_record(1) = time_record(1) + 1;
				%else col_state(i) = 0;
				end
			else
				if (rand(1) < prb_repair)
					col_state(i) = 0;
				%else col_state(i) = 1;
				end
			end
		end			
						
		fail_flag_old = fail_flag_new;
		srs_fail_flag_old = srs_fail_flag_new;
		
		for i = 1:5
			if (sum(soft_state(i,:)) + sum(hard_state(i,:)) + sum(inter_state(i,:)) > 0)
				sys_state(i) = 1;
			else sys_state(i) = 0;
			end
		end	
		
		if (sum(col_state(:))>0)
			sys_state(6) = 1;
		else sys_state(6) = 0;
		end

		sum_comp1 = sys_state(1) + sys_state(3) + sys_state(4) + sys_state(5) + sys_state(6);
		sum_comp2 = sys_state(2) + sys_state(3) + sys_state(4) + sys_state(5) + sys_state(6);
		
		if (sum_comp1 + sum(stk_flag(2,:)) == 0 && sum_comp2 + sum(stk_flag(1,:)) == 0)
			fail_flag_new = 0;
			time_flag = time_flag + 1;
			time_record(6) = time_record(6) + 1;
		else 
			fail_flag_new = 1;
			time_flag = 0;
		end		
						
		sum_state = sys_state(3) + sys_state(4) + sys_state(5);				
					
		if (sys_state(1) + sys_state(2) >= 2 || sys_state(6) || sum(stk_flag(:)) > 0 || sum_state >= 2)
			srs_fail_flag_new = 1;
		else srs_fail_flag_new = 0;
		end				
						
		if (fail_flag_old > fail_flag_new)
			time_record(2) = time_record(2) + 1;
		end
	
		if (fail_flag_new + fail_flag_old == 0)
			time_record(4) = time_record(4) + 1;
		end
	
		if (srs_fail_flag_old > srs_fail_flag_new)
			time_record(3) = time_record(3) + 1;
		end
	
		if (srs_fail_flag_new + srs_fail_flag_old == 0)
			time_record(5) = time_record(5) + 1;
		end
	
		if (life == 87600)
			time_record(4) = time_record(4) - time_flag;
			time_record(5) = time_record(5) - time_flag;
		end	
		
		if (life == 1)
			if (fail_flag_new == 0)
				avail(m,1) = 1;
			end
		end
		
		if (life == 2)
			if (fail_flag_new == 0)
				avail(m,2) = 1;
			end
		end	
		
		if (life == 8)
			if (fail_flag_new == 0)
				avail(m,3) = 1;
			end
		end
		
		if (life == 20)
			if (fail_flag_new == 0)
				avail(m,4) = 1;
			end
		end
		
		if (life == 100)
			if (fail_flag_new == 0)
				avail(m,5) = 1;
			end
		end
		
		if (life == 1000)
			if (fail_flag_new == 0)
				avail(m,6) = 1;
			end
		end
		
		if (life == 8760)
			if (fail_flag_new == 0)
				avail(m,7) = 1;
			end
		end
		
		if (life == 43800)
			if (fail_flag_new == 0)
				avail(m,8) = 1;
			end
		end
		
		if (life == 87600)
			if (fail_flag_new == 0)
				avail(m,9) = 1;
			end
		end
		
	end
	record(m,1)=time_record(1);
	record(m,2)=time_record(2);
	record(m,3)=time_record(3);
	record(m,4)=time_record(4)/time_record(2);
	record(m,5)=time_record(5)/time_record(3);
	record(m,6)=time_record(6);
    
    m
    t = toc
end	

%dlmwrite('data0.txt',record);
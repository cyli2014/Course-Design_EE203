la = 92000; %lambda A
lb = 390000; %lambda B
number = 10000; %模拟次数
for m = 5:1:12
	ra = exprnd(la,m,number); 
	rb = exprnd(lb,m,number);
	ra = sort(ra); %将随机数从小到大排列
	rb = sort(rb);
	t = 0; 
	for s = 1:1:number %开始 number 次模拟
		pa = 1; 
		pb = 1;
		ppa = 0; %用来记录系统状态变化
		ppb = 0;
		for k = 1:1:m %初始化
			a(k) = 0; %第 k 个节点 A 的状态
			b(k) = 0; %第 k 个节点 B 的状态
			n(k) = 0; %第 k 个节点的节点状态
		end
			while ppa ~= pa || ppb ~= pb %系统状态变化
				ppa = pa;
				ppb = pb;
				if ra(pa,s) < rb(pb,s) && a(pa) == 0 %切换器 A 先发生故障
					r = rand(1);
					t = ra(pa,s);
				if r < 0.19
					a(pa) = 1;
				elseif r < 0.44
					a(pa) = 2;
				else
					a(pa) = 3;
				end %随机 A 的故障类型
				if pa < m
					pa = pa + 1; %系统状态变化
				end
				elseif b(pb) == 0 %切换器 B 先发生故障
					r = rand(1);
					t = rb(pb,s);
				if r < 0.65
					b(pb) = 1;
				else
					b(pb) = 2;
				end %随机 B 的故障类型
				if pb < m
					pb = pb + 1; %系统状态变化
				end
			end
          
			for k = 1:1:m %节点状态更新
				sum = a(k)*10 + b(k);
				if sum == 0
					n(k) = 0;
				elseif sum == 2 || sum == 10 || sum == 12
					n(k) = 1;
				elseif sum == 20
					n(k) = 2;
				elseif sum == 1 || sum == 21
					n(k) = 3;
				elseif sum == 22 || sum == 30 || sum == 31 || sum ==22
					n(k) = 4;
				elseif sum == 11
					n(k) = 5;
				end
			end
          
			c5 = 0;
			c6 = 0;
			c7 = 0;
			c8c9 = 0; %系统能否正常工作的判断条件
			cnt_n0 = 0; %pf 的个数
			cnt_n1 = 0; %so 的个数
			cnt_n2 = 0; %dm 的个数
			cnt_n3 = 0; %mo 的个数
			cnt_n5 = 0; %fb 的个数
			for k = 1:1:m %计算 n0 到 n5 的个数
				if n(k) == 5
					cnt_n5 = cnt_n5 + 1;
				end
				if n(k) == 3
					cnt_n3 = cnt_n3 + 1;
				end
				if n(k) == 0
					cnt_n0 = cnt_n0 + 1;
				end
				if n(k) == 1
					cnt_n1 = cnt_n1 + 1;
				end
				if n(k) == 2
					cnt_n2 = cnt_n2 + 1;
				end
			end
			
			if cnt_n5 == 0 %判断 C5 是否成立
				c5 = 1;
			end
			if cnt_n3 == 1 && cnt_n0 + cnt_n1 > 2 %判断 C6 是否成立
				c6 = 1;
			end
			if (cnt_n3 == 0 && cnt_n0 > 0 && cnt_n0 + cnt_n1 > 3) ||(cnt_n0 == 0 && cnt_n3 == 0 && cnt_n2 > 0 && cnt_n1 > 2)
				c7 = 1; %判断 C7 是否成立
			end
			if (cnt_n5 + cnt_n3 == 0 && cnt_n0 + cnt_n1 ==3) %判断 C8C9 是否成立
				r = rand(1);
				if r < cnt_n2 / (cnt_n2 + cnt_n0)
					c8c9 = 1;
				end
			end
			if ~((c5 && (c6 || c7)) || c8c9) %判断系统是否能有效工作
				time(m,s) = t; %记录系统工作的最大时间
            break; %不能继续工作则退出环
        end
    end
end
	count(m) = 0; %系统可靠性
	sumoftime(m) = 0; %系统平均工作寿命
	for s = 1:1:number
		if time(m,s) >= 25000 || time(m,s) == 0
			count(m) = count(m) + 1; %计算能工作 25000h的系统
		end
		if time(m,s) == 0 || time(m,s) > 80000
			sumoftime(m) = sumoftime(m) + 80000;
		else
			sumoftime(m) = sumoftime(m) + time(m,s);%计算系统总寿命
		end
	end
	count(m) = count(m)/number; %计算可靠性
	sumoftime(m) = sumoftime(m)/number; %计算系统平均工作寿命
end

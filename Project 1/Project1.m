la = 92000; %lambda A
lb = 390000; %lambda B
number = 10000; %ģ�����
for m = 5:1:12
	ra = exprnd(la,m,number); 
	rb = exprnd(lb,m,number);
	ra = sort(ra); %���������С��������
	rb = sort(rb);
	t = 0; 
	for s = 1:1:number %��ʼ number ��ģ��
		pa = 1; 
		pb = 1;
		ppa = 0; %������¼ϵͳ״̬�仯
		ppb = 0;
		for k = 1:1:m %��ʼ��
			a(k) = 0; %�� k ���ڵ� A ��״̬
			b(k) = 0; %�� k ���ڵ� B ��״̬
			n(k) = 0; %�� k ���ڵ�Ľڵ�״̬
		end
			while ppa ~= pa || ppb ~= pb %ϵͳ״̬�仯
				ppa = pa;
				ppb = pb;
				if ra(pa,s) < rb(pb,s) && a(pa) == 0 %�л��� A �ȷ�������
					r = rand(1);
					t = ra(pa,s);
				if r < 0.19
					a(pa) = 1;
				elseif r < 0.44
					a(pa) = 2;
				else
					a(pa) = 3;
				end %��� A �Ĺ�������
				if pa < m
					pa = pa + 1; %ϵͳ״̬�仯
				end
				elseif b(pb) == 0 %�л��� B �ȷ�������
					r = rand(1);
					t = rb(pb,s);
				if r < 0.65
					b(pb) = 1;
				else
					b(pb) = 2;
				end %��� B �Ĺ�������
				if pb < m
					pb = pb + 1; %ϵͳ״̬�仯
				end
			end
          
			for k = 1:1:m %�ڵ�״̬����
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
			c8c9 = 0; %ϵͳ�ܷ������������ж�����
			cnt_n0 = 0; %pf �ĸ���
			cnt_n1 = 0; %so �ĸ���
			cnt_n2 = 0; %dm �ĸ���
			cnt_n3 = 0; %mo �ĸ���
			cnt_n5 = 0; %fb �ĸ���
			for k = 1:1:m %���� n0 �� n5 �ĸ���
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
			
			if cnt_n5 == 0 %�ж� C5 �Ƿ����
				c5 = 1;
			end
			if cnt_n3 == 1 && cnt_n0 + cnt_n1 > 2 %�ж� C6 �Ƿ����
				c6 = 1;
			end
			if (cnt_n3 == 0 && cnt_n0 > 0 && cnt_n0 + cnt_n1 > 3) ||(cnt_n0 == 0 && cnt_n3 == 0 && cnt_n2 > 0 && cnt_n1 > 2)
				c7 = 1; %�ж� C7 �Ƿ����
			end
			if (cnt_n5 + cnt_n3 == 0 && cnt_n0 + cnt_n1 ==3) %�ж� C8C9 �Ƿ����
				r = rand(1);
				if r < cnt_n2 / (cnt_n2 + cnt_n0)
					c8c9 = 1;
				end
			end
			if ~((c5 && (c6 || c7)) || c8c9) %�ж�ϵͳ�Ƿ�����Ч����
				time(m,s) = t; %��¼ϵͳ���������ʱ��
            break; %���ܼ����������˳���
        end
    end
end
	count(m) = 0; %ϵͳ�ɿ���
	sumoftime(m) = 0; %ϵͳƽ����������
	for s = 1:1:number
		if time(m,s) >= 25000 || time(m,s) == 0
			count(m) = count(m) + 1; %�����ܹ��� 25000h��ϵͳ
		end
		if time(m,s) == 0 || time(m,s) > 80000
			sumoftime(m) = sumoftime(m) + 80000;
		else
			sumoftime(m) = sumoftime(m) + time(m,s);%����ϵͳ������
		end
	end
	count(m) = count(m)/number; %����ɿ���
	sumoftime(m) = sumoftime(m)/number; %����ϵͳƽ����������
end

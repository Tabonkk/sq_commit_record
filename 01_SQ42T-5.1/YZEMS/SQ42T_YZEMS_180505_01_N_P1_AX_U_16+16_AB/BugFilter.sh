#使用方法:将ftp中的时间范围内的txt文档和info文档，拷贝至此文件目录下面（只复制user版本）
#运行程序： ./BugFilter.sh "过滤定制类的关键字" | grep -E 'SQ27TC|ALL'
#每一步都产生一个文件，最终文件是:XXXX修改点整理.xlsx，其次，打印出来的内容是具有bugid的bug，可以人工填入表格

#获取文件前缀
PWD=`pwd`
DIR=${PWD##*/}
PREFIX=${DIR%0*}
#echo PREFIX=$PREFIX
#echo DIR=$DIR

#合并文件
cat *AB.info > all_log_0.info
cat *AB.txt > all_log_0.txt

#去除重复行
awk '{print FNR"\t"$0}' all_log_0.txt |sort -u -k 2 -t $'\t'|sort -n -k 1 -t $'\t' |awk '{$1="";print $0}' > clean_duplicated_log_1.txt

#删除关键词所在行
#if [ $# -ne 0 ];then
	ARGS=$(echo $* 软件验证 软件自测 软件自检 编译错误 编译异常 软件测试|awk '{gsub(" ","|");print $0}')
	grep -vE $ARGS clean_duplicated_log_1.txt | grep '<.*>'  > filter_by_key_2.txt
#else
#	grep '<.*>' clean_duplicated_log_1.txt  > filter_by_name_2.txt
#fi

#删除原来的并创建新的文件
#rm  replace_name_table_3.xls
rm $PREFIX'修改点整理'.xlsx
cp ../修改点整理.xlsx  ./$PREFIX修改点整理.xlsx

#替换名字
cat filter_by_key_2.txt | while read line
do
	#echo $line;
	str_title_1=${line%<*}
    str_title_2=${str_title_1#*]:}
	str_name_id=${line##*<}

	case $str_name_id in
	     "Rocky>")
			str_name="谢基富"
		;; 
	     "Huazhong Wu>")
		        str_name="吴华中"
		;;
		"luolin>")
			str_name="罗林"
		;;
		"gouwei>")
			str_name="苟威"
		;;
		"zhouxin>")
			str_name="周鑫"
		;;
		"wujinquan>")
			str_name="巫金全"
		;;
		"cb>")
			str_name="陈斌"
		;;
		"M5>")
			str_name="胡宝育"
		;;
		"qiuzhoujun>")
			str_name="邱周军"
		;;
		"Aod>")
			str_name="刘佳科"
		;;
		"liujk>")
			str_name="刘佳科"
		;;
		"GeShiping>")
			str_name="戈士平"
		;;
		"DengTonglong>")
			str_name="邓同龙"
		;;
		"wenyian>")
			str_name="文益安"
		;;
		"yian.wen>")
			str_name="文益安"
		;;
		"Xueyuan Bai>")
			str_name="白雪源"
		;;
		"baixueyuan>")
			str_name="白雪源"
		;;
		"baoyu.hu>")
			str_name="胡宝育"
		;;
		"Qrepo>")
			str_name="胡宝育"
		;;
		"oumaojiang>")
			str_name="欧茂江"
		;;
		"ShiXiaoKai>")
			str_name="石晓凯"
		;;
		"jiqing lu>")
			str_name="卢极清"
		;;
		"qianbo.li>")
			str_name="李钱波"
		;;
		"liqianbo>")
			str_name="李钱波"
		;;
		"jiaxinxin>")
			str_name="贾欣欣"
		;;
		"hechao>")
			str_name="何超"
		;;
	     *)
		    str_name=$str_name_id	
		;;
	esac
	#填写整理修改点表格
	((n++))
	python ../write_modify.py $n  "$str_title_2" $str_name $PREFIX 
	#echo $n $n  $str_title_2 $str_name $PREFIX
	#echo -e "$str_title_2\t$str_name"  >>  replace_name_table_3.xls
done


#筛选有bugID的内容
cat  all_log_0.info | grep ['[0-9]\{4,8\}']  





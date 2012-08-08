# encoding: utf-8
require 'nokogiri'

module Spider
	class WinxuanParser < Parser
 CATEGORY_MAP = [
 ["文学-民间文学", "图书音像-文艺-文学"],
 ["文学-诗歌散文", "图书音像-文艺-文学"],
 ["文学-文学名著", "图书音像-文艺-文学"],
 ["文学-古典文学", "图书音像-文艺-文学"],
 ["文学-传记", "图书音像-文艺-文学"],
 ["文学-历史古籍", "图书音像-文艺-文学"],
 ["文学-四大名著", "图书音像-文艺-文学"],
 ["文学-文学理论", "图书音像-文艺-文学"],
 ["小说-武侠", "图书音像-文艺-小说"],
 ["小说-科幻、侦探", "图书音像-文艺-小说"],
 ["小说-中国当代小说", "图书音像-文艺-小说"],
 ["小说-外国小说", "图书音像-文艺-小说"],
 ["艺术-美术设计", "图书音像-文艺-艺术"],
 ["艺术-音乐舞蹈", "图书音像-文艺-艺术"],
 ["艺术-书法篆刻", "图书音像-文艺-艺术"],
 ["艺术-工艺收藏", "图书音像-文艺-艺术"],
 ["艺术-幽默漫画", "图书音像-文艺-艺术"],
 ["艺术-影视理论", "图书音像-文艺-艺术"],
 ["艺术-摄影", "图书音像-文艺-艺术"],
 ["人文社科-社科综合", "图书音像-人文社科-文化"],
 ["人文社科-法律", "图书音像-经管-法律"],
 ["人文社科-历史", "图书音像-人文社科-历史"],
 ["人文社科-成功学", "图书音像-人文社科-心理学"],
 ["人文社科-哲学", "图书音像-人文社科-哲学"],
 ["人文社科-政治", "图书音像-人文社科-政治"],
 ["人文社科-旅游", "图书音像-生活-旅游地图"],
 ["人文社科-心理学", "图书音像-人文社科-心理学"],
 ["人文社科-新闻传播", "图书音像-人文社科-文化"],
 ["人文社科-宗教", "图书音像-人文社科-宗教"],
 ["人文社科-法律考试、教材", "图书音像-经管-法律"],
 ["人文社科-军事", "图书音像-人文社科-军事"],
 ["人文社科-公务员考试", "图书音像-教育-考试"],
 ["人文社科-地理", "图书音像-科技-科学/自然"],
 ["经济-经济理论", "图书音像-经管-经济"],
 ["经济-经济考试", "图书音像-经管-经济"],
 ["经济-财会", "图书音像-经管-经济"],
 ["经济-财政金融", "图书音像-经管-经济"],
 ["经济-商贸", "图书音像-经管-经济"],
 ["经济-工具书", "图书音像-经管-经济"],
 ["管理-管理理论、实务", "图书音像-经管-管理"],
 ["管理-管理运作", "图书音像-经管-管理"],
 ["管理-职业经理", "图书音像-经管-管理"],
 ["管理-营销", "图书音像-经管-管理"],
 ["管理-财富论坛", "图书音像-经管-管理"],
 ["管理-人力资源", "图书音像-经管-管理"],
 ["管理-企业管理", "图书音像-经管-管理"],
 ["管理-战略管理", "图书音像-经管-管理"],
 ["生活-生活休闲", "图书音像-生活-动漫/幽默"],
 ["生活-美食", "图书音像-生活-美食"],
 ["生活-地图", "图书音像-生活-保健"],
 ["生活-妇幼保健", "图书音像-生活-保健"],
 ["生活-家庭保健", "图书音像-生活-保健"],
 ["少儿-智力开发", "图书音像-生活-育儿"],
 ["少儿-注音读物", "图书音像-生活-育儿"],
 ["少儿-童话故事", "图书音像-生活-育儿"],
 ["少儿-综合读物", "图书音像-生活-育儿"],
 ["少儿-儿童文学", "图书音像-生活-育儿"],
 ["少儿-卡片挂图", "图书音像-生活-育儿"],
 ["少儿-卡通漫画", "图书音像-生活-育儿"],
 ["少儿-启蒙", "图书音像-生活-育儿"],
 ["少儿-少儿科普", "图书音像-生活-育儿"],
 ["少儿-少儿艺术", "图书音像-生活-育儿"],
 ["少儿-少儿英语", "图书音像-生活-育儿"],
 ["少儿-手工制作", "图书音像-生活-育儿"],
 ["科技-机械工程", "图书音像-科技-科技工程"],
 ["科技-电子技术", "图书音像-科技-科技工程"],
 ["科技-建筑", "图书音像-科技-建筑"],
 ["科技-西医", "图书音像-科技-医学"],
 ["科技-水利电力", "图书音像-科技-科技工程"],
 ["科技-轻工", "图书音像-科技-科技工程"],
 ["科技-中医", "图书音像-科技-医学"],
 ["科技-交通运输", "图书音像-科技-科技工程"],
 ["科技-冶金、地质", "图书音像-科技-科技工程"],
 ["科技-汽摩维修", "图书音像-科技-科技工程"],
 ["科技-农业科技", "图书音像-科技-科技工程"],
 ["科技-基础科学", "图书音像-科技-科学/自然"],
 ["科技-化工", "图书音像-科技-科技工程"],
 ["科技-计量标准", "图书音像-科技-科技工程"],
 ["科技-工具书", "图书音像-教育-工具书"],
 ["计算机-编程语言", "图书音像-科技-计算机/互联网"],
 ["计算机-网络技术", "图书音像-科技-计算机/互联网"],
 ["计算机-网页制作", "图书音像-科技-计算机/互联网"],
 ["计算机-英文原版书", "图书音像-科技-计算机/互联网"],
 ["计算机-计算机考试", "图书音像-科技-计算机/互联网"],
 ["计算机-软硬件技术", "图书音像-科技-计算机/互联网"],
 ["计算机-输入法", "图书音像-科技-计算机/互联网"],
 ["计算机-工具书", "图书音像-科技-计算机/互联网"],
 ["计算机-图形图像", "图书音像-科技-计算机/互联网"],
 ["计算机-基础培训", "图书音像-科技-计算机/互联网"],
 ["计算机-操作系统", "图书音像-科技-计算机/互联网"],
 ["计算机-数据库", "图书音像-科技-计算机/互联网"],
 ["教辅-高中教辅", "图书音像-教育-中小学教辅"],
 ["教辅-小学教辅", "图书音像-教育-中小学教辅"],
 ["教辅-奥赛", "图书音像-教育-中小学教辅"],
 ["外语-等级考试", "图书音像-教育-考试"],
 ["外语-考研英语", "图书音像-教育-考试"],
 ["外语-出国考试", "图书音像-教育-考试"],
 ["外语-外语应用", "图书音像-教育-外语学习"],
 ["外语-外语类学术专著", "图书音像-教育-外语学习"],
 ["外语-外语类读物", "图书音像-教育-外语学习"],
 ["外语-小语种", "图书音像-教育-外语学习"],
 ["文化教育-语言文字", "图书音像-教育-语言文字"],
 ["文化教育-读物", "图书音像-教育-期刊"],
 ["文化教育-工具书", "图书音像-教育-工具书"],
 ["文化教育-作文", "图书音像-教育-教材"],
 ["文化教育-学生字帖", "图书音像-教育-教材"],
 ["文化教育-常备书籍", "图书音像-教育-教材"],
 ["文化教育-教参教案", "图书音像-教育-教材"],
 ["文化教育-教学教具", "图书音像-教育-教材"],
 ["文化教育-教育理论", "图书音像-教育-教材"],
 ["文化教育-文娱体育", "图书音像-科技-体育/运动"],
 ["教辅-初中教辅", "图书音像-教育-中小学教辅"],
 ["音像-流行音乐-大陆流行音乐CD", "图书音像-音像-音乐"],
 ["音像-流行音乐-港台音乐CD", "图书音像-音像-音乐"],
 ["音像-流行音乐-日韩音乐CD", "图书音像-音像-音乐"],
 ["音像-流行音乐-欧美音乐CD", "图书音像-音像-音乐"],
 ["音像-流行音乐-流行音乐音带", "图书音像-音像-音乐"],
 ["音像-电子音乐-舞曲音乐CD", "图书音像-音像-音乐"],
 ["音像-电子音乐-舞曲音乐音带", "图书音像-音像-音乐"],
 ["音像-古典音乐-外国古典音乐CD", "图书音像-音像-音乐"],
 ["音像-古典音乐-外国古典音乐音带", "图书音像-音像-音乐"],
 ["音像-儿童音乐-儿童音乐/舞曲CD", "图书音像-音像-音乐"],
 ["音像-儿童音乐-儿童音乐/舞曲音带", "图书音像-音像-音乐"],
 ["音像-儿童音乐-儿童歌曲CD", "图书音像-音像-音乐"],
 ["音像-儿童音乐-儿童歌曲音带", "图书音像-音像-音乐"],
 ["音像-儿童音乐-儿童故事CD", "图书音像-音像-音乐"],
 ["音像-儿童音乐-儿童故事音带", "图书音像-音像-音乐"],
 ["音像-名族音乐-民乐CD", "图书音像-音像-音乐"],
 ["音像-名族音乐-民乐音带", "图书音像-音像-音乐"],
 ["音像-名族音乐-大陆民歌歌曲CD", "图书音像-音像-音乐"],
 ["音像-名族音乐-大陆民歌歌曲音带", "图书音像-音像-音乐"],
 ["音像-休闲音乐-国内轻音乐CD", "图书音像-音像-音乐"],
 ["音像-休闲音乐-国外轻音乐CD", "图书音像-音像-音乐"],
 ["音像-休闲音乐-健身CD", "图书音像-音像-音乐"],
 ["音像-休闲音乐-礼仪CD", "图书音像-音像-音乐"],
 ["音像-休闲音乐-休闲音乐音带", "图书音像-音像-音乐"],
 ["音像-发烧碟-发烧音乐CD", "图书音像-音像-音乐"],
 ["音像-发烧碟-发烧歌曲CD", "图书音像-音像-音乐"],
 ["音像-戏曲/曲艺-戏剧/戏曲CD", "图书音像-音像-音乐"],
 ["音像-戏曲/曲艺-戏剧/戏曲音带", "图书音像-音像-音乐"],
 ["音像-影视音乐-KTV(VCD)", "图书音像-音像-音乐"],
 ["音像-影视音乐-KTV(DVD)", "图书音像-音像-音乐"],
 ["音像-影视音乐-MTV(VCD)", "图书音像-音像-音乐"],
 ["音像-影视音乐-MTV(DVD)", "图书音像-音像-音乐"],
 ["音像-进口音乐-进口音乐CD", "图书音像-音像-音乐"],
 ["音像-进口音乐-进口歌曲CD", "图书音像-音像-音乐"],
 ["音像-进口音乐-进口古典CD", "图书音像-音像-音乐"],
 ["音像-进口音乐-进口音乐音带", "图书音像-音像-音乐"],
 ["音像-进口音乐-进口歌曲音带", "图书音像-音像-音乐"],
 ["音像-进口音乐-进口古典音带", "图书音像-音像-音乐"],
 ["音像-影视-电影VCD", "图书音像-音像-电影"],
 ["音像-影视-电影DVD电视剧VCD", "图书音像-音像-电影"],
 ["音像-影视-电视剧DVD", "图书音像-音像-电影"],
 ["音像-影视-儿童故事VCD", "图书音像-音像-电影"],
 ["音像-影视-儿童故事DVD科普教育VCD", "图书音像-音像-电影"],
 ["音像-影视-科普教育DVD", "图书音像-音像-电影"],
 ["音像-影视-儿童音乐VCD", "图书音像-音像-电影"],
 ["音像-影视-儿童音乐DVD", "图书音像-音像-电影"],
 ["音像-影视-儿童歌曲VCD", "图书音像-音像-电影"],
 ["音像-影视-儿童歌曲DVD", "图书音像-音像-电影"],
 ["音像-影视-儿童舞蹈VCD", "图书音像-音像-电影"],
 ["音像-影视-儿童舞蹈DVD", "图书音像-音像-电影"],
 ["音像-影视-儿童科普教育VCD", "图书音像-音像-电影"],
 ["音像-影视-儿童科普教育DVD", "图书音像-音像-电影"],
 ["音像-影视-音乐/风光VCD", "图书音像-音像-电影"],
 ["音像-影视-音乐/风光DVD", "图书音像-音像-电影"],
 ["音像-影视-健身VCD", "图书音像-音像-电影"],
 ["音像-影视-健身DVD戏剧VCD", "图书音像-音像-电影"],
 ["音像-影视-戏剧DVD", "图书音像-音像-电影"],
 ["音像-软件-电脑游戏类软件", "图书音像-音像-教育"],
 ["音像-软件-动漫类软件工具类软件", "图书音像-音像-教育"],
 ["音像-软件-系统应用软件", "图书音像-音像-教育"],
 ["音像-软件-课堂教学软件", "图书音像-音像-教育"],
 ["音像-软件-语言教育软件", "图书音像-音像-教育"],
 ["音像-软件-电脑知识软件", "图书音像-音像-教育"],
 ["音像-软件-百科教育软件", "图书音像-音像-教育"],
 ["音像-软件-MP3类软件", "图书音像-音像-教育"],
 ["音像-管理教学-管理类VCD", "图书音像-音像-教育"],
 ["音像-管理教学-管理类DVD", "图书音像-音像-教育"],
 ["音像-教辅-学龄前教育音带", "图书音像-音像-教育"],
 ["音像-教辅-学龄前教育CD", "图书音像-音像-教育"],
 ["音像-教辅-学龄前教育VCD", "图书音像-音像-教育"],
 ["音像-教辅-小学各科教辅音带", "图书音像-音像-教育"],
 ["音像-教辅-小学各科教辅CD", "图书音像-音像-教育"],
 ["音像-教辅-小学各科教辅VCD", "图书音像-音像-教育"],
 ["音像-教辅-小学各科教辅DVD", "图书音像-音像-教育"],
 ["音像-教辅-初中各科教辅音带", "图书音像-音像-教育"],
 ["音像-教辅-初中各科教辅CD", "图书音像-音像-教育"],
 ["音像-教辅-初中各科教辅VCD", "图书音像-音像-教育"],
 ["音像-教辅-初中各科教辅DVD", "图书音像-音像-教育"],
 ["音像-教辅-高中各科教辅音带", "图书音像-音像-教育"],
 ["音像-教辅-高中各科教辅CD", "图书音像-音像-教育"],
 ["音像-教辅-高中各科教辅VCD", "图书音像-音像-教育"],
 ["音像-教辅-高中各科教辅DVD", "图书音像-音像-教育"],
 ["音像-英语-学龄前英语音带", "图书音像-音像-教育"],
 ["音像-英语-学龄前英语CD", "图书音像-音像-教育"],
 ["音像-英语-学龄前英语VCD", "图书音像-音像-教育"],
 ["音像-英语-学龄前英语DVD", "图书音像-音像-教育"],
 ["音像-英语-小学英语音带", "图书音像-音像-教育"],
 ["音像-英语-小学英语CD", "图书音像-音像-教育"],
 ["音像-英语-小学英语VCD小学英语DVD", "图书音像-音像-教育"],
 ["音像-英语-初中英语音带", "图书音像-音像-教育"],
 ["音像-英语-初中英语CD", "图书音像-音像-教育"],
 ["音像-英语-初中英语VCD初中英语DVD", "图书音像-音像-教育"],
 ["音像-英语-高中英语音带", "图书音像-音像-教育"],
 ["音像-英语-高中英语CD", "图书音像-音像-教育"],
 ["音像-英语-高中英语VCD高中英语DVD", "图书音像-音像-教育"],
 ["音像-英语-大学英语音带", "图书音像-音像-教育"],
 ["音像-英语-大学英语CD", "图书音像-音像-教育"],
 ["音像-英语-大学英语VCD", "图书音像-音像-教育"],
 ["音像-英语-大学英语DVD", "图书音像-音像-教育"],
 ["音像-英语-研究生英语音带", "图书音像-音像-教育"],
 ["音像-英语-研究生英语CD", "图书音像-音像-教育"],
 ["音像-英语-研究生英语VCD", "图书音像-音像-教育"],
 ["音像-英语-研究生英语DVD", "图书音像-音像-教育"],
 ["音像-英语-大众英语音带", "图书音像-音像-教育"],
 ["音像-英语-大众英语CD", "图书音像-音像-教育"],
 ["音像-英语-大众英语VCD", "图书音像-音像-教育"],
 ["音像-英语-大众英语DVD", "图书音像-音像-教育"],
 ["音像-英语-出国培训音带", "图书音像-音像-教育"],
 ["音像-英语-出国培训CD出国培训DVD", "图书音像-音像-教育"],
 ["音像-英语-外语读物音带", "图书音像-音像-教育"],
 ["音像-英语-外语读物CD", "图书音像-音像-教育"],
 ["音像-英语-外语读物VCD", "图书音像-音像-教育"],
 ["音像-英语-外语读物DVD", "图书音像-音像-教育"],
 ["音像-考试-大学英语考级音带", "图书音像-音像-教育"],
 ["音像-考试-大学英语考级CD", "图书音像-音像-教育"],
 ["音像-考试-大学英语考级VCD", "图书音像-音像-教育"],
 ["音像-考试-大学英语考级DVD", "图书音像-音像-教育"],
 ["音像-考试-专业英语考级音带", "图书音像-音像-教育"],
 ["音像-考试-专业英语考级CD", "图书音像-音像-教育"],
 ["音像-考试-专业英语考级VCD", "图书音像-音像-教育"],
 ["音像-考试-专业英语考级DVD", "图书音像-音像-教育"],
 ["音像-考试-职称考试音带", "图书音像-音像-教育"],
 ["音像-考试-职称考试CD", "图书音像-音像-教育"],
 ["音像-考试-职称考试VCD", "图书音像-音像-教育"],
 ["音像-考试-职称考试DVD", "图书音像-音像-教育"],
 ["音像-小语种-日语音带", "图书音像-音像-教育"],
 ["音像-小语种-日语CD", "图书音像-音像-教育"],
 ["音像-小语种-日语VCD", "图书音像-音像-教育"],
 ["音像-小语种-日语DVD", "图书音像-音像-教育"],
 ["音像-小语种-韩语音带", "图书音像-音像-教育"],
 ["音像-小语种-韩语CD", "图书音像-音像-教育"],
 ["音像-小语种-韩语VCD", "图书音像-音像-教育"],
 ["音像-小语种-韩语DVD", "图书音像-音像-教育"],
 ["音像-小语种-法语音带", "图书音像-音像-教育"],
 ["音像-小语种-法语CD", "图书音像-音像-教育"],
 ["音像-小语种-法语VCD", "图书音像-音像-教育"],
 ["音像-小语种-法语DVD", "图书音像-音像-教育"],
 ["音像-小语种-德语音带", "图书音像-音像-教育"],
 ["音像-小语种-德语CD", "图书音像-音像-教育"],
 ["音像-小语种-德语VCD", "图书音像-音像-教育"],
 ["音像-小语种-德语DVD", "图书音像-音像-教育"],
 ["音像-小语种-其他语种音带", "图书音像-音像-教育"],
 ["音像-小语种-其他语种CD", "图书音像-音像-教育"],
 ["音像-小语种-其他语种VCD", "图书音像-音像-教育"],
 ["音像-小语种-其他语种DVD", "图书音像-音像-教育"],
 ["百货-箱包-女包", "箱包皮具-潮流女包-手提包"],
 ["百货-箱包-男包", "箱包皮具-时尚男包-手包"],
 ["百货-箱包-户外旅行包", "箱包皮具-旅行箱包-运动包"],
 ["百货-箱包-功能箱包", "箱包皮具-旅行箱包-多功能背包"],
 ["百货-手表-时尚品牌", "珠宝配饰-手表钟表-时尚品牌"],
 ["百货-手表-瑞士品牌", "珠宝配饰-手表钟表-瑞士名表"],
 ["百货-手表-欧美品牌", "珠宝配饰-手表钟表-瑞士名表"],
 ["百货-手表-日韩品牌", "珠宝配饰-手表钟表-日本名表"],
 ["百货-手表-配件工具", "珠宝配饰-手表钟表-挂钟/闹钟"],
 ["百货-数码产品-手机", "电脑手机数码-手机通讯-普通手机"],
 ["百货-数码产品-电脑", "电脑手机数码-电脑整机-笔记本"],
 ["百货-数码产品-摄影摄像", "电脑手机数码-数码摄像-数码摄像机"],
 ["百货-数码产品-娱乐视听", "电脑手机数码-时尚影音-高清播放器"],
 ["百货-数码产品-数码相框", "电脑手机数码-时尚影音-数码相框"],
 ["百货-数码产品-录音笔", "电脑手机数码-时尚影音-录音笔"],
 ["百货-数码产品-移动储存", "电脑手机数码-电脑外设产品-移动硬盘"],
 ["百货-数码产品-相片打印机", "电脑手机数码-数码配件-其他"],
 ["百货-生活家电-厨卫电器", "家电/办公-厨房家电-其他"],
 ["百货-生活家电-个人护理", "家电/办公-小家电-电动牙刷"],
 ["百货-生活家电-家具电器", "家电/办公-生活家电-空调"],
#家具用品
#茶叶
 ["百货-美装-美容护肤", "美容护肤-日常护肤-洁面"],
 ["百货-美装-个人护理用品", "美容护肤-身体护理-个护保健"],
#食品
 ["百货-母婴-纸类用品", "母婴-日用品-孕婴清洁护肤"],
 ["百货-母婴-洗护", "母婴-日用品-孕婴清洁护肤"],
 ["百货-母婴-奶粉", "母婴-宝贝食品-羊奶粉"],
 ["百货-母婴-婴儿用具", "母婴-日用品-餐具"],
 ["百货-母婴-辅食", "母婴-宝贝食品-果肉泥"]
#围巾/帽子
#玩具
]

    def belongs_to_categories
			doc.css("div.your_path.cl a").select{|elem| elem["href"] && elem["href"].to_s != "http://www.winxuan.com/"}[0,2].map do |elem|
        {
          :name => elem.inner_text,
          :url  => elem["href"]
        }
			end
   end

		def title
			doc.css("h1.goods_title").text.strip
		end

		def price
			doc.css("ul.price_info b.fb").text.strip.match(/[\d|\.]+$/)[0].to_f
		end

		def stock
      1
      #doc.css("ul.price_info li span.red").last.text
			#doc.css("ul.price_info b.red").text.strip.match(/[\d|\.]+$/)[0].to_i
		end

		def image_url
			doc.css("div.goods_pic img").first[:src]
		end

		def desc
		end

		def price_url
		end

		def score
                  1
		end

		def product_code
		end
		
		def standard
		end
		
		def comments
			content_elems = doc.css("div.comment_content p")
			review_elems = doc.css(".reviewer")
			publish_at_elems = doc.css("div.reviewer span.fr")
			(0...review_elems.count).map do |index|
				{
					publish_at: publish_at_elems[index].inner_text,
					content: content_elems[2*index - 1].inner_text
				}
			end	
		end
		
		def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")
      puts route_str
      origin_base_map(CATEGORY_MAP,route_str)
		end

		def get_union_url
                  "http://union.xinhuabookstore.com/Tracker/Tracker.html?customerID=662&url="+product.url
		end
		
		def merchant
                                    get_merchant("文轩网")
		end
		
		def brand
		end

		def brand_type
		end

		def get_order_num
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")

      order_num_end_product = origin_base_map(CATEGORY_MAP,route_str)

      if order_num_end_product.nil?
        10000000
      else
        order_num_end_product.order_num
      end
		end

	end
end

1.结构
.
|-- Gemfile
|-- Gemfile.lock
|-- TODO
|-- config
|   `-- mongoid.yml
|-- digger
|   |-- dangdang_digger.rb
|   |-- taobao_digger.rb
|   `-- tmall_digger.rb
|-- digger.rb
|-- downloader
|   |-- em_downloader.rb
|   |-- normal_downloader.rb
|   `-- ty_downloader.rb
|-- downloader.rb
|-- encoding.rb
|-- fetcher
|   |-- dangdang_fetcher.rb
|   |-- jingdong_fetcher.rb
|   |-- newegg_fetcher.rb
|   |-- taobao_fetcher.rb
|   `-- tmall_fetcher.rb
|-- fetcher.rb
|-- log
|   |-- class.log
|   |-- dangdang_parser.log
|   |-- em_downloader.log
|   |-- normal_downloader.log
|   |-- run_dangdang_parser.log
|   `-- ty_downloader.log
|-- logger.rb
|-- models
|   |-- body.rb
|   |-- category.rb
|   |-- comment.rb
|   |-- page.rb
|   |-- product.rb
|   `-- shop.rb
|-- paginater
|   |-- dangdang_paginater.rb
|   |-- newegg_paginater.rb
|   |-- taobao_paginater.rb
|   `-- tmall_paginater.rb
|-- paginater.rb
|-- parser
|   |-- dangdang_parser.rb
|   |-- jingdong_parser.rb
|   |-- taobao_parser.rb
|   `-- tmall_parser.rb
|-- parser.rb
|-- script
|   |-- console
|   |-- run_digger
|   |-- run_fetcher
|   |-- run_paginater
|   `-- run_parser
`-- utils
    |-- optparse.rb
    `-- utils.rb
2.运行环境：ruby1.9.2+

  sudo apt-get install libcurl4-gnutls-dev

3.各个模块功能：
 1.fetcher负责获取网站总分类，是爬虫其他模块的基础
 2.paginater负责获取分页信息
 3.digger负责获取产品URL
 4.parser负责解析从产品URL中抽取出有用信息
 5.logger负责日志
 6.encoding负责编码转换，解析等
 7.downloader负责从网络获取页面HTML，包含三个模块(单线程、多线程、EventIO)
 8.script负责启动各个模块，并将获取内容存入数据库
4.script启动参数
 script/run_parser -h帮助信息
 script/run_parser -eproduction -dty -ndangdang
 其中－e为环境（production/development）默认为development.
 -d为以什么方式下载(ty->多线程，normal ->单线程, em -> EventIO)默认为normal,推荐使用ty参数。
 -s为指定运行哪个网站(dangdang,jingdong,etc)默认是当当
5.启动顺序
 fetcher -> paginater -> digger -> parser

$ ./script/run_parser -h
Usage: run_parser [options]
    -s, --name=spider_name           input spider name to run
                                     Default: dangdang
    -e, --environment=name           Specifies the environment to run this spider under (development/production).
                                     Default: development
    -d, --downloader=name            Specifies the downloader to run this spider under (normal/ty/em)
                                     Default: normal
    -n, --number=number              Specifies the number to load from database.
                                     Default: 1000

    -h, --help                       Show this help message.

  Parser Attributes:
def title
end

def price
end

def stock
end

def image_url
end

def desc
end

def price_url
end

def score
end

def product_code
end

def standard
end

def comments
end

def end_product
end

def merchant
end

def brand
end

def brand_type
end


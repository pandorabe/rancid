# RANCIDでYAMAHAルーターのコンフィグを管理

1.概要  
OSSプロダクトであるRANCID(Really Awesome New Cisco config Fiffer)を使って、  
YAMAHAルーターのコンフィグを管理できるようにしてみました。

RANCIDの詳細は以下をご覧ください  
<http://www.shruberry.net/rancid/>  

一応、雑な感じのChefレシピも書いてあり、インストールしたら２つの定義ファイルを追記すれば、
そのまま利用できる、、、はずです。  

  RANCIDではおなじみviewvcもセットにしていますので、ブラウザからコンフィグの  
  差分確認ができます。  

2.当方環境および注意点  
OS　CentOS6.5(64bit)  
　その他の動作は確認していませんが、Cent６系であれば問題ないと思います。  
　
RANCID　2.3.6

RANCIDはyumでインストールするレシピのため、  
事前にepelのレポジトリをインストールしておくか、opscodeのyumレシピを  
ゲットしておいてください。  

chefのattributeにはデフォルト設定値が入っており、以下のようになっています。  
default['rancid']['mailsender'] = 'root@localhost'　　# RANCIDのメール通知先   
default['rancid']['group'] = 'networking'             # RANCIDの管理グループ(CVSレポジトリの単位)  
default['rancid']['fromip'] = '192.168.'　　　　　　　# VIEWVCのアクセス許可NW  


3.簡単な使い方  
 A.すでに環境がある場合  
  RANCIDの環境がある方は以下のyloginとyrancidをご自身の環境にあわせて  
  配備してください。  
  
  <https://github.com/pandorabe/rancid/tree/master/cookbooks/rancid/files/default>  

   RANCIDのコマンドディレクトリ配下に置いてください　例: /usr/libexec/rancid  
 
  また、上記パスあるrancid-fe内のvendortableにYAMAHAの定義を追記してください。  
   
   %vendortable = (  
    'agm'               => 'agmrancid',  
    'alteon'            => 'arancid',  
    中略   
    'yamaha'            => 'yrancid',　　# ここを追記  
    'zebra'             => 'zrancid'  
   );  
 
 B.Chefを使う場合は、以下を実施してください。  
　(1)node/rancidhost.json  
　　　デフォルトのattribute値を変更したい場合は、こちらに定義を記述するとよいと思います。  
　　　また、opscodeのyum(epel)を使う場合は、epelの処理が先に行われるように記述してください。  
　(2)インストール後に対象サーバへログインし以下のファイルを修正してください。  
　　　/var/rancid/.cloginrc  
　　　  YAMAHAのログイン情報を記載してください。以下はtelnet接続時の一例  
　　　    add user 172.16.0.254 hoge  
　        add password 172.16.0.254 passwd adminpasswd   
　        
　        # hogeの部分にログインユーザ名を記載  
　        # passwd、adminpasswdの部分にはそれぞれ、ユーザーログインパスワードとadminパスワードを記載  
　         
　   /var/rancid/networking/router.db  
　      以下のようにルーター情報を記載してください。  
　      　172.16.0.254:yamaha:up  
　      　
　 (3)その他  
　 　　- 細かい設定はされていませんので、マニュアルを見ながら使用してみてください。  
　 　　- レシピの設定では、1日1回cronによりコンフィグを自動取得します。(/etc/cron.d/rancid)  
　 　　- snmpのコミュニティ名は削除して表示する設定になっています。  
　 　　− viewvcには以下のURLでアクセスしてください。  
　 　　　http://<serverip>/viewvc/  
　 　　- なにぶんシロウトが見よう見まねで作ったものですので動作がおかしい部分があったらすみません。  
　 　　　(ちなみにRANCIDは値を取得するだけで設定を変更したり壊す事はありません)  
　 

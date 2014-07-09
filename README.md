# RANCIDでYAMAHAルーターのコンフィグを管理

1.概要  
OSSプロダクトであるRANCID(Really Awesome New Cisco config Fiffer)を使って、  
YAMAHAルーターのコンフィグを管理できるようにしてみました。

RANCIDの詳細は以下をご覧ください  
<http://www.shrubberry.net/rancid/>  

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

*chefのattributeにはデフォルト設定値が入っており、以下のようになっています。*  
`default['rancid']['mailsender'] = 'root@localhost'`　　# RANCIDのメール通知先   
`default['rancid']['group'] = 'networking'`             # RANCIDの管理グループ(CVSレポジトリの単位)  
`default['rancid']['fromip'] = '192.168.'`　　　　　　　# VIEWVCのアクセス許可NW  

3.簡単な使い方  
- *A.すでに環境がある場合*  
RANCIDの環境がある方は以下のylogin、yrancidとrancid-feをご自身の環境にあわせて配備してください。  
  
<https://github.com/pandorabe/rancid/tree/master/cookbooks/rancid/files/default>  

*対象サーバ上のRANCIDコマンドディレクトリ配下に置いてください　例: /usr/libexec/rancid  
 
- *B.Chefを使う場合は、以下を実施してください。*  
(1)node/<hostname>.jsonの修正    
デフォルトのattribute値を変更したい場合は、こちらに定義を記述するとよいと思います。  
また、opscodeのyum(epel)を使う場合は、epelの処理がRANCIDより先に行われるように記述してください。  
(レシピのdefault.rb内にyumレシピをinclude記述しても良いかもしれません)  

(2)インストール後に対象サーバへログインし以下のファイルを修正  
- /var/rancid/.cloginrc  
 YAMAHAのログイン情報を記載してください。以下はtelnet接続時の一例  
 `add user 172.16.0.254 hoge`  
 `add password 172.16.0.254 passwd adminpasswd`  
　        
 # hogeの部分にログインユーザ名を記載  
 # passwd、adminpasswdの部分にはそれぞれ、ユーザーログインパスワードとadminパスワードを記載  
　         
- /var/rancid/networking/router.db  
  以下のようにルーター情報を記載してください。  
  `172.16.0.254:yamaha:up`  

(3)その他  
- 細かい設定はされていませんので、マニュアルを見ながらRANCIDやviewvcを使用(設定変更)してみてください。  
- /etc/cron.d/rancidを修正してcronによる実行タイミングを設定してください。  
また、ログの削除設定がデフォルトでは存在しないので、以下のように設定できるとよろしいかと思います。  
`30 23 * * * rancid /usr/bin/find /var/log/rancid -type f -mtime +2 -exec rm {} \;`  
- snmpのコミュニティ名は削除して表示する設定になっています。  
- viewvcには以下のURLでアクセスしてください。  
http://<serverip>/viewvc/  
- なにぶんシロウトが見よう見まねで作ったものですので動作がおかしい部分があったらすみません。(ちなみにRANCIDは値を取得するだけで設定を変更したり壊す事はありません)  
　 

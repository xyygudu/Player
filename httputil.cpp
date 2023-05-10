#include "httputil.h"
#include <QNetworkReply>
#include <QDebug>
#include <QByteArray>
#include <QJsonParseError>



HttpUtil::HttpUtil(QString baseUrl, QString lyricBaseUrl,QObject *parent)
    : QObject{parent}
    , m_baseUrl(baseUrl)
    , m_lyricBaseUrl(lyricBaseUrl)
{
    m_netWorkManeger = new QNetworkAccessManager(this);
    connect(m_netWorkManeger, SIGNAL(finished(QNetworkReply *)), this, SLOT(replyFinished(QNetworkReply *)));
}

void HttpUtil::replyFinished(QNetworkReply *reply)
{
    QByteArray searchInfo = reply->readAll();
    QJsonParseError err;
    //将json文本转换为 json 文件对象
    QJsonDocument json_recv = QJsonDocument::fromJson(searchInfo,&err);
    if(err.error != QJsonParseError::NoError)    //判断是否符合语法
    {
        qDebug() <<"搜索歌曲Json获取格式错误"<< err.errorString();
        return;
    }
    QJsonObject totalObject = json_recv.object();
    emit parseJson(totalObject);
}

void HttpUtil::searchMusic(QString musicName)
{
    QString requestlUrl = m_baseUrl  + musicName;
    QNetworkRequest request;
    request.setUrl(requestlUrl);
    // 发送请求
    m_netWorkManeger->get(request);
}

void HttpUtil::getLyrics(int musicId)
{
    QString requestlUrl = m_lyricBaseUrl  + QString::number(musicId);
    QNetworkRequest request;
    request.setUrl(requestlUrl);
    // 发送请求
    m_netWorkManeger->get(request);
}

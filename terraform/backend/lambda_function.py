import json
import os
import pg8000.native

def lambda_handler(event, context):
    db_host = os.environ['DB_HOST']
    db_user = "saitadmin" 
    db_pass = "Sait123456!"
    db_name = "postgres"
    
    try:
        con = pg8000.native.Connection(
            user=db_user,
            password=db_pass,
            host=db_host,
            database=db_name
        )
        
        # 1. TEMİZLİK: Önce eski tabloyu ve verileri tamamen uçuruyoruz (Hard Reset)
        con.run("DROP TABLE IF EXISTS urunler;")
        
        # 2. TABLOYU YENİDEN KUR
        create_table_query = """
        CREATE TABLE urunler (
            id SERIAL PRIMARY KEY,
            isim VARCHAR(100),
            fiyat INTEGER,
            resim VARCHAR(255)
        );
        """
        con.run(create_table_query)
        
        # 3. YENİ VERİLERİ EKLE (Tırnak hatası düzeltildi + Resim linkleri düzeltildi)
        insert_query = """
        INSERT INTO urunler (isim, fiyat, resim) VALUES 
        ('Retro Masa Saati', 500, 'https://images.unsplash.com/photo-1541480601022-2308c0f02487?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        ('Mavi Antik Vazo', 1500, 'https://images.unsplash.com/photo-1603252712049-274984b09f48?q=80&w=2340&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        ('Modern Seramik Vazo', 850, 'https://images.unsplash.com/photo-1694003670659-a7b3e4841efb?q=80&w=1335&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        ('El Yapımı Toprak Vazo', 1200, 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=300&q=80');
        """
        con.run(insert_query)

        # 4. SONUCU ÇEK
        select_query = "SELECT * FROM urunler;"
        rows = con.run(select_query)
        
        urun_listesi = []
        for row in rows:
            urun_listesi.append({
                "id": row[0],
                "isim": row[1],
                "fiyat": row[2],
                "resim": row[3]
            })

        con.close()
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*', # CORS hatası almamak için
                'Access-Control-Allow-Methods': 'GET, OPTIONS'
            },
            'body': json.dumps({
                'mesaj': "Tablo sıfırlandı ve 4 yeni ürün eklendi! 🚀",
                'urunler': urun_listesi
            }, ensure_ascii=False)
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f"HATA OLUŞTU: {str(e)}")
        }
import { useState, useEffect } from 'react'
import './App.css'

// --- BURAYA DİKKAT ---
// AWS Lambda URL'ini tırnak içine yapıştır:
const API_URL = "https://sxi1l7ojy1.execute-api.us-east-1.amazonaws.com/";
// ---------------------

function App() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    // Component yüklendiğinde çalışır (ComponentDidMount)
    fetch(API_URL)
      .then(response => {
        if (!response.ok) throw new Error('Bağlantı Hatası');
        return response.json();
      })
      .then(data => {
        setProducts(data.urunler);
        setLoading(false);
      })
      .catch(err => {
        console.error("Hata:", err);
        setError("ACCESS DENIED - SYSTEM FAILURE");
        setLoading(false);
      });
  }, []);

  return (
    <div className="app-container">
      <h1>The Prestige Collection</h1>

      {loading && <div className="loading">CONNECTING TO PRIVATE VAULT...</div>}
      
      {error && <div style={{color: 'red', fontSize: '1.5rem'}}>{error}</div>}

     <div className="gallery">
        {products.map(item => (
          <div key={item.id} className="card">
            {/* HATA 1: item.image -> item.resim */}
            <img src={item.resim} alt={item.isim} /> 
            
            <div className="info">
              <div className="category">{item.category || 'Exclusive'}</div>
              <h3>{item.isim}</h3>
              <p className="description">En iyiler.</p> 
              
              <div className="price">
                {new Intl.NumberFormat('tr-TR', { 
                    style: 'currency', 
                    currency: 'TRY', 
                    maximumFractionDigits: 0 
                }).format(item.fiyat)}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

export default App
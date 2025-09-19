// criando as variáveis 
document.addEventListener("DOMContentLoaded", function() {
    const nao = document.getElementById('nao');
    nao.addEventListener("mouseover", function(){
        let x = Math.random() * (window.innerWidth - nao.offsetWidth);
        let y = Math.random() * (window.innerHeight - nao.offsetHeight)
        nao.style.position = "absolute";
        nao.style.left = `${x}px`;
        nao.style.top = `${y}px`;
    });
    const neko = document.getElementById('gato');
    const sim = document.getElementById('sim');
    const pedido = document.getElementById('pedido');
    const Neko = document.getElementById('Gato');
    const som = document.getElementById('som');
    const som2 = document.getElementById('som2');
    const fundo = document.body;
    
    window.aceito = function(){
        neko.style.display = 'block';
        sim.style.display = 'none';
        nao.style.display = 'none';
        pedido.style.display = 'none';
        som.play();

        let x = Math.random() * (window.innerWidth - neko.offsetWidth);
        let y = Math.random() * (window.innerHeight - neko.offsetHeight);
        let currentX = parseInt(neko.style.left) || 0;
        let currentY = parseInt(neko.style.top) || 0;
    
        function moveNeko() {
            let deltaX = x - currentX;
            let deltaY = y - currentY;

            if (Math.abs(deltaX) > 1 || Math.abs(deltaY) > 1) {
                currentX += deltaX * 0.05; 
                currentY += deltaY * 0.05;
    
                neko.style.left = `${currentX}px`;
                neko.style.top = `${currentY}px`;
    
                requestAnimationFrame(moveNeko);
            } else {
                x = Math.random() * (window.innerWidth - neko.offsetWidth);
                y = Math.random() * (window.innerHeight - neko.offsetHeight);
    
                setTimeout(() => {
                    requestAnimationFrame(moveNeko);
                }, 100);
            }
        }
    
        requestAnimationFrame(moveNeko);
    }
    window.recuso = function(){
        som2.play();
        sim.style.display = 'none';
        nao.style.display = 'none';
        Neko.style.display = 'block';
        pedido.style.display = 'none';
        fundo.style.backgroundImage = "url('download.jpg')";
        fundo.style.backgroundSize = "cover";
    }
});
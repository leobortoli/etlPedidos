# etlPedidos: Uma prática de Python, Pandas e SQL!
Fiz esse projeto baseado no do Ankit Bansal, engenheiro de dados da Amazon. Decidi fazê-lo porque preciso treinar com projetos
e passei tempo de mais estudando Python para Data Science e SQL, então era necessário botar a mão na massa, mesmo que seja um
projeto simples!
## Foram utilizados:
* **Bibliotecas:**
    * Kaggle: Para download do conjunto de dados (download manual também funciona, caso não queira usar).
    * MariaDB: Conector para interação com o banco de dados.
    * Pandas: Para manipulação e transformação dos dados.
    * SQLAlchemy: Para conexão e interação com o banco de dados SQL.
    * Zipfile: Para extração do arquivo compactado.
* **Banco de Dados:** MariaDB 127.0.0.1 com HeidiSQL.
## Visão Geral do Projeto:
O projeto consiste em um script Python que realiza as seguintes etapas:

1.  **Extração:**
    * Download do conjunto de dados de pedidos de venda do Kaggle (opcional, o arquivo pode ser baixado manualmente).
    * Extração dos dados de um arquivo ZIP.
2.  **Transformação:**
    * Carregamento dos dados em um DataFrame do Pandas.
    * Limpeza e formatação dos dados (tratamento de valores nulos, conversão de tipos).
    * Cálculo de novas colunas (desconto, preço de venda, lucro).
    * Remoção de colunas redundantes.
3.  **Carga:**
    * Carregamento dos dados transformados em uma tabela do banco de dados MariaDB.
## Vídeo:
O principal embasamento veio desse vídeo:
<a href='https://youtu.be/uL0-6kfiH3g?si=ZRn_uzjG-gcbFZig' target='_blank'>
<img src='https://i.ytimg.com/vi/uL0-6kfiH3g/hq720.jpg?sqp=-oaymwEnCNAFEJQDSFryq4qpAxkIARUAAIhCGAHYAQHiAQoIGBACGAY4AUAB&rs=AOn4CLB2LmHmzJZslY1oz_M_RrcoYImr_w' alt='Clique Aqui' wdith='240' heigth='180' border='10'>
</a>
<br>

### Fim 

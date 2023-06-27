library(stringr)
library(tm)
library(dplyr)
library(e1071)


# Definir as texto para cada idioma

texto_portugues <- c(
  "A chegada do verão traz consigo o sol escaldante e a brisa refrescante do mar.",
  "O protagonista da história era um jovem corajoso, disposto a enfrentar qualquer desafio.",
  "Os cientistas realizaram um estudo detalhado para analisar os efeitos do novo medicamento.",
  "A praia estava repleta de banhistas aproveitando o dia ensolarado.",
  "O artista apresentou uma exposição de suas obras de arte no renomado museu.",
  "O livro narra a emocionante jornada de um viajante solitário em busca da felicidade.",
  "O filme ganhou diversos prêmios por sua cinematografia impressionante e sua narrativa envolvente.",
  "O mercado está cada vez mais competitivo, exigindo que as empresas inovem constantemente.",
  "A cidade estava em festa, com música, dança e alegria espalhadas por todos os cantos.",
  "O professor explicou de forma clara e concisa o conteúdo da aula, facilitando o entendimento dos alunos.",
  "A chuva torrencial inundou as ruas, causando transtornos no trânsito da cidade.",
  "O atleta se dedicou intensamente aos treinos e conquistou a medalha de ouro nas Olimpíadas.",
  "A reunião foi produtiva, com os participantes discutindo ideias e propondo soluções.",
  "O casal apaixonado caminhou de mãos dadas pela praça, compartilhando momentos de cumplicidade.",
  "A criança sorriu ao receber o presente, expressando sua felicidade de forma contagiante.",
  "A paisagem deslumbrante do pôr do sol refletia-se nas águas calmas do lago.",
  "O escritor renomado lançou seu mais recente romance, que se tornou um best-seller imediatamente.",
  "O time de futebol venceu a partida com um gol nos últimos minutos, levando a torcida ao delírio.",
  "A empresa anunciou a abertura de novas vagas de emprego, gerando esperança para os desempregados.",
  "A crise econômica afetou severamente a indústria, resultando em demissões em massa.",
  "A comida caseira servida no restaurante era saborosa e feita com ingredientes frescos.",
  "O museu abrigava uma vasta coleção de arte contemporânea, atraindo visitantes de todo o mundo.",
  "A natureza exuberante da floresta encantava os exploradores que se aventuravam por suas trilhas.",
  "O político discursou sobre a importância da educação como base para o desenvolvimento do país.",
  "O sorriso no rosto da idosa era um reflexo da gratidão que sentia pelos cuidados recebidos.",
  "A cantora emocionou a plateia com sua voz potente e interpretação cheia de sentimento.",
  "O projeto de construção do novo prédio foi aprovado, trazendo perspectivas de crescimento para a cidade.",
  "O estilista lançou uma nova coleção de roupas inspirada nas tendências internacionais da moda.",
  "A tecnologia avançada permitiu a criação de dispositivos inteligentes que facilitam o dia a dia das pessoas.",
  "O livro de autoajuda oferece dicas práticas para alcançar o equilíbrio emocional e a felicidade plena."
)

# Exemplos de parágrafos em espanhol
texto_espanhol <- c(
  "El sol brillaba intensamente en el cielo despejado, iluminando el paisaje con su cálido resplandor.",
  "El perro ladró fuerte, alertando a su dueño de la presencia de un extraño.",
  "El viajero cansado encontró refugio en una pequeña posada en medio de la montaña.",
  "La fiesta estaba en pleno apogeo, con música, baile y risas por todas partes.",
  "El pintor talentoso creó una obra maestra que capturaba la belleza del paisaje marino.",
  "La película provocó una variedad de emociones en el público, desde risas hasta lágrimas.",
  "El equipo de fútbol celebró su victoria con entusiasmo y alegría desbordante.",
  "La comida picante dejó un sabor intenso en el paladar, despertando los sentidos.",
  "El actor principal interpretó su papel con maestría, cautivando al público con su actuación.",
  "El libro de historia relata los acontecimientos que llevaron a la caída de un imperio antiguo.",
  "El investigador presentó los resultados de su estudio en una conferencia internacional.",
  "La artista exhibió sus esculturas en una galería de arte reconocida a nivel mundial.",
  "El río fluía suavemente, reflejando los colores vibrantes del paisaje circundante.",
  "La ciudad estaba envuelta en una densa niebla, creando una atmósfera misteriosa.",
  "El músico talentoso tocó su guitarra con destreza, llenando el ambiente con su melodía.",
  "El niño observaba maravillado los fuegos artificiales que iluminaban el cielo nocturno.",
  "El director de la empresa anunció la apertura de nuevas sucursales en todo el país.",
  "La crisis económica afectó a la industria, resultando en despidos masivos.",
  "La familia disfrutaba de un tranquilo paseo por el parque, disfrutando del buen tiempo.",
  "El sol se ponía lentamente en el horizonte, tiñendo el cielo de tonos dorados y rojizos.",
  "El escritor famoso publicó su última novela, que rápidamente se convirtió en un éxito de ventas.",
  "El estudiante dedicado se esforzó al máximo y logró obtener excelentes calificaciones en sus exámenes.",
  "El chef preparó un plato exquisito con ingredientes frescos y de alta calidad.",
  "El atleta se preparó arduamente para la competencia y finalmente alcanzó la medalla de oro.",
  "La actriz brilló en el escenario con su interpretación convincente y llena de pasión.",
  "El arquitecto diseñó un edificio moderno y funcional que se integra perfectamente con el entorno.",
  "La música suave y melódica llenaba el ambiente, creando una atmósfera de paz y tranquilidad.",
  "El mercado estaba abarrotado de gente, comprando productos frescos y coloridos en los puestos.",
  "La sociedad actual enfrenta numerosos desafíos, desde el cambio climático hasta la desigualdad social.",
  "El profesor explicó los conceptos complejos de manera clara y comprensible para los estudiantes."
)

# Exemplos de parágrafos em italiano
texto_italiano <- c(
  "Il bambino saltellava felice nel parco, godendosi il sole e l'aria fresca.",
  "Il pittore talentuoso dipinse un quadro che catturava la bellezza del paesaggio marino.",
  "La città era animata da rumori, voci e il suono dei motori delle auto.",
  "La pioggia battente rendeva le strade scivolose e gli ombrelli erano ovunque.",
  "La famiglia si riunì attorno al tavolo per condividere un delizioso pranzo fatto in casa.",
  "Il film era pieno di suspense e colpi di scena, tenendo il pubblico sulle spine.",
  "Il cantante emozionò il pubblico con la sua voce potente e la sua presenza magnetica.",
  "La pasta fresca preparata dallo chef era un tripudio di sapori e profumi deliziosi.",
  "L'atleta si allenò duramente per raggiungere la forma fisica ottimale per la gara.",
  "Il romanzo romantico racconta una storia appassionante di amore e destino.",
  "Il mercato era affollato di persone che facevano la spesa e chiacchieravano animatamente.",
  "Il progetto di costruzione del nuovo edificio è stato approvato, dando impulso all'economia locale.",
  "Il politico pronunciò un discorso appassionato sull'importanza dell'istruzione per il futuro del paese.",
  "La città storica era un labirinto di stradine acciottolate e antichi edifici di grande fascino.",
  "Il suono delle onde che si infrangevano sulla riva creava un'atmosfera rilassante.",
  "La dolce melodia del pianoforte riempiva la stanza, creando un'atmosfera di tranquillità.",
  "Il cuoco preparò una cena gourmet, combinando sapientemente ingredienti freschi e di alta qualità.",
  "Il libro di cucina conteneva ricette tradizionali che rappresentavano la cultura del paese.",
  "La primavera portò con sé la rinascita della natura, con fiori colorati che sbocciavano ovunque.",
  "Il viaggiatore avventuroso si immerse nella cultura locale, scoprendo tradizioni uniche.",
  "La montagna imponente si ergeva maestosa, offrendo una vista spettacolare sulla valle sottostante.",
  "Il medico esperto fornì consigli preziosi per mantenere una buona salute fisica e mentale.",
  "La compagnia di danza eseguì una performance eccezionale che incantò il pubblico presente.",
  "Il museo ospitava una vasta collezione di opere d'arte, dalle sculture ai dipinti famosi.",
  "L'amore tra i due protagonisti del film era così intenso da toccare il cuore dello spettatore.",
  "Il compositore talentuoso creò una sinfonia commovente che emozionò il pubblico presente.",
  "La città era famosa per la sua cucina raffinata, offrendo una vasta scelta di ristoranti di alta qualità.",
  "Il tramonto dipingeva il cielo con sfumature arancioni e rosa, creando un'atmosfera magica.",
  "Il museo storico raccontava la storia del paese attraverso reperti e documenti preziosi.",
  "Il libro di poesie era una raccolta di versi intensi e profondi, che toccavano l'anima del lettore."
)

# Exemplos de parágrafos em inglês
texto_ingles <- c(
  "The city skyline was illuminated by the vibrant colors of the fireworks, creating a mesmerizing display.",
  "The young girl eagerly opened the gift, her eyes sparkling with excitement.",
  "The novel explores themes of love, betrayal, and redemption in a captivating narrative.",
  "The scientist conducted a series of experiments to test the hypothesis and analyze the results.",
  "The majestic mountains stretched as far as the eye could see, creating a breathtaking panorama.",
  "The company implemented a new strategy to improve efficiency and increase productivity.",
  "The actor delivered a powerful performance that left the audience in awe.",
  "The museum exhibits showcased a diverse collection of artwork from different periods in history.",
  "The rain poured down relentlessly, drenching everything in its path.",
  "The teacher provided clear explanations and examples to help the students understand the concept.",
  "The sun cast a golden glow over the tranquil lake, reflecting the beauty of nature.",
  "The athlete broke the world record, achieving a remarkable feat in their sport.",
  "The concert was a sensory delight, with vibrant visuals and captivating music.",
  "The entrepreneur started a successful business from scratch, overcoming numerous challenges.",
  "The ancient ruins stood as a testament to a bygone era, captivating the imagination of visitors.",
  "The speaker delivered an inspiring keynote speech that resonated with the audience.",
  "The bustling city streets were filled with the sounds of traffic and people going about their day.",
  "The novel's plot twists kept readers on the edge of their seats, eager to uncover the truth.",
  "The photographer captured a breathtaking sunset, with hues of orange and pink painting the sky.",
  "The technology revolutionized the way we communicate, connecting people across the globe.",
  "The team celebrated their hard-earned victory, cheering and embracing each other.",
  "The fashion designer showcased their latest collection on the runway, receiving rave reviews.",
  "The documentary shed light on important social issues, sparking a conversation for change.",
  "The newborn baby's cry filled the room, bringing joy and excitement to the new parents.",
  "The professor's lecture was thought-provoking, challenging the students to question their assumptions.",
  "The beach stretched for miles, with soft sand and crystal-clear waters inviting visitors to relax.",
  "The CEO delivered a passionate speech, outlining the company's vision for the future.",
  "The train whizzed by, its lights flashing and horn blaring, as it rushed towards its destination.",
  "The wildlife safari offered a glimpse into the untamed beauty of nature, with animals in their natural habitat.",
  "The medical breakthrough gave hope to patients suffering from a previously incurable disease."
)

# Exemplos de parágrafos em francês
texto_frances <- c(
  "La ville était animée par les sons des voitures et des conversations animées des passants.",
  "Le soleil se levait lentement à l'horizon, répandant ses rayons dorés sur la campagne.",
  "Le chef cuisinier préparait un délicieux festin, mélangeant habilement les saveurs et les textures.",
  "Le roman captivant racontait l'histoire d'une femme courageuse qui défiait les conventions sociales.",
  "Le tableau du peintre célèbre dépeignait un paysage enchanteur baigné de couleurs vives.",
  "La danseuse étoile exécutait des mouvements gracieux et élégants, captivant le public.",
  "Le château médiéval se dressait fièrement sur la colline, témoignant de son riche passé historique.",
  "La musique douce et mélodieuse emplissait la pièce, créant une atmosphère de sérénité.",
  "Le marchand ambulant vendait ses produits frais sur le marché animé de la ville.",
  "Le joueur de football marqua un superbe but, déclenchant l'enthousiasme des supporters.",
  "La tempête rugissante secouait les arbres, faisant voler les feuilles dans tous les sens.",
  "Le médecin expérimenté prodiguait des soins attentionnés à ses patients, les aidant à guérir.",
  "Le film poignant racontait l'histoire bouleversante d'une famille séparée par la guerre.",
  "La journée ensoleillée invitait les gens à sortir et à profiter de la nature.",
  "Le musicien talentueux jouait du piano avec virtuosité, envoûtant l'auditoire par sa musique.",
  "La ville pittoresque était entourée de paysages magnifiques, offrant de superbes opportunités de randonnée.",
  "Le parfum envoûtant des fleurs embaumait l'air, créant une ambiance romantique.",
  "La pièce de théâtre divertissante faisait rire aux éclats le public, avec ses répliques hilarantes.",
  "Le scientifique faisait des découvertes révolutionnaires qui ouvraient de nouvelles perspectives de recherche.",
  "Le voyageur curieux explorait les rues étroites de la vieille ville, découvrant des trésors cachés.",
  "La voix de l'opéra était puissante et émouvante, remplissant la salle de son timbre envoûtant.",
  "Le poète écrivait des vers inspirés, exprimant ses émotions les plus profondes.",
  "La mode française était réputée dans le monde entier pour son style élégant et sophistiqué.",
  "Le café pittoresque était le lieu de rendez-vous préféré des artistes et des intellectuels.",
  "La conférence internationale réunissait des experts de différents pays pour discuter des enjeux mondiaux.",
  "Le village côtier offrait des paysages époustouflants, avec ses falaises escarpées et ses plages de sable fin.",
  "Le roman policier était rempli de rebondissements et de mystères, tenant le lecteur en haleine jusqu'à la fin.",
  "Le parfum délicat des croissants fraîchement sortis du four emplissait la boulangerie.",
  "La réunion d'affaires était l'occasion de discuter des nouveaux projets et des objectifs de l'entreprise.",
  "Le monument emblématique était un symbole de fierté nationale, attirant des milliers de visiteurs chaque année."
)

# Exemplos de parágrafos em alemão
texto_alemao <- c(
  "Die Sonne strahlte am blauen Himmel und tauchte die Landschaft in warmes Licht.",
  "Das Kind spielte fröhlich im Park und genoss die Sonne und frische Luft.",
  "Der talentierte Maler malte ein Bild, das die Schönheit der Meereslandschaft einfing.",
  "Die Stadt war erfüllt von Geräuschen, Stimmen und dem Klang von Autos.",
  "Der strömende Regen machte die Straßen rutschig und Regenschirme waren überall zu sehen.",
  "Die Familie versammelte sich um den Tisch, um ein köstliches hausgemachtes Mittagessen zu teilen.",
  "Der Film war voller Spannung und Wendungen, die das Publikum in Atem hielten.",
  "Der Sänger begeisterte das Publikum mit seiner kraftvollen Stimme und seiner magnetischen Präsenz.",
  "Die frische Pasta des Küchenchefs war eine Explosion von köstlichen Aromen und Düften.",
  "Der Athlet trainierte hart, um in Topform für den Wettkampf zu sein.",
  "Der romantische Roman erzählt eine fesselnde Geschichte von Liebe und Schicksal.",
  "Der Markt war überfüllt mit Menschen, die einkauften und angeregt miteinander sprachen.",
  "Das Bauprojekt für das neue Gebäude wurde genehmigt und brachte Schwung in die lokale Wirtschaft.",
  "Der Politiker hielt eine leidenschaftliche Rede über die Bedeutung von Bildung für die Zukunft des Landes.",
  "Die historische Stadt war ein Labyrinth aus kopfsteingepflasterten Gassen und faszinierenden alten Gebäuden.",
  "Der Klang der Wellen, die an den Strand rollten, schuf eine entspannte Atmosphäre.",
  "Die sanfte Melodie des Klaviers erfüllte den Raum und schuf eine Atmosphäre der Ruhe.",
  "Der Koch bereitete ein Gourmet-Abendessen zu, indem er frische und hochwertige Zutaten geschickt kombinierte.",
  "Das Kochbuch enthielt traditionelle Rezepte, die die Kultur des Landes repräsentierten.",
  "Der Frühling brachte die Wiederbelebung der Natur mit sich, mit bunten Blumen, die überall blühten.",
  "Der abenteuerlustige Reisende erkundete die Welt und entdeckte verschiedene Kulturen und faszinierende Orte.",
  "Der imposante Berg erhob sich majestätisch und bot eine atemberaubende Aussicht auf das darunterliegende Tal.",
  "Der erfahrene Arzt gab wertvolle Ratschläge zur Erhaltung von körperlicher und mentaler Gesundheit.",
  "Die Tanzkompanie führte eine herausragende Vorstellung auf, die das Publikum begeisterte.",
  "Das Museum präsentierte eine vielfältige Sammlung von Kunstwerken aus verschiedenen Epochen.",
  "Der Liebe zwischen den beiden Hauptfiguren des Films war so intensiv, dass sie das Herz der Zuschauer berührte.",
  "Der talentierte Komponist schuf eine bewegende Sinfonie, die das Publikum begeisterte.",
  "Die Stadt war für ihre exquisite Küche bekannt und bot eine Vielzahl von hochwertigen Restaurants.",
  "Der Sonnenuntergang malte den Himmel mit orangen und rosa Farbtönen und schuf eine magische Atmosphäre.",
  "Das historische Museum erzählte die Geschichte des Landes anhand von kostbaren Artefakten und Dokumenten."
)


df <- data.frame(idioma = character(), texto = character(), stringsAsFactors = FALSE)
df <- rbind(df, data.frame(idioma = "portugues", texto = texto_portugues))
df <- rbind(df, data.frame(idioma = "ingles", texto = texto_ingles))
df <- rbind(df, data.frame(idioma = "espanhol", texto = texto_espanhol))
df <- rbind(df, data.frame(idioma = "alemao", texto = texto_alemao))
df <- rbind(df, data.frame(idioma = "frances", texto = texto_frances))
df <- rbind(df, data.frame(idioma = "italiano", texto = texto_italiano))

write.csv2(df, "dados.csv", fileEncoding = "UTF-8", row.names = FALSE)


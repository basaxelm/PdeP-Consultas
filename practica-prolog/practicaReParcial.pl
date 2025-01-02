% publicacion(Fecha, Post).
publicacion(fecha(25, 01, 2013), tuid(coirotomas, ["es", "mi", "cumple", "arrodíllense"])).
publicacion(fecha(26, 01, 2014), tuid(fanDeTusk, ["paga", "Tuiderr", "en", "vez", "de", "quejarte", "queridito"])).
publicacion(fecha(06, 07, 2014), tuid(matifreyre, ["que", "bueno", "Les", "Luthiers"])).
publicacion(fecha(25, 12, 2014), tuid(melonTusk, ["ser", "millonario", "es", "más", "difícil", "que", "ser", "pobre"])).
publicacion(fecha(23, 07, 2023), tuid(melonTusk, ["ahora", "se", "llama", "Z"])).
publicacion(fecha(18, 05, 2024), tuid(alumnoFrustrado, ["pdep", "hace", "los", "peores", "parciales"])).
publicacion(fecha(05, 06, 2024), retuid(fanDeTusk, tuid(melonTusk, ["ser", "millonario", "es", "más", "difícil", "que", "ser", "pobre"]))).
publicacion(fecha(18, 05, 2024), retuid(alumno2, tuid(alumnoFrustrado, ["pdep", "hace", "los", "peores", "parciales"]))).
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "mas", "contenido", "gatito", "enBio"])).
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "menos", "contenido", "gatito", "enBio"])).
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "otro", "contenido", "gatito", "enBio"])).
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "diferente", "contenido", "gatito", "enBio"])).
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "parecido", "contenido", "gatito", "enBio"])).
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "distinto", "contenido", "gatito", "enBio"])).
publicacion(fecha(23, 06, 2024), tuid(coirotomas, ["compren", "bitcoin", "es", "el", "futuro"])).
publicacion(fecha(27, 06, 2024), tuid(estafador238, ["cryptos", "gratis", "en", "link", "pongan", "datos"])).
publicacion(fecha(06, 07, 2024), retuid(matifreyre, tuid(matifreyre, ["que", "bueno", "Les", "Luthiers"]))).

% paraAprobar(Fecha, Post).
paraAprobar(fecha(20, 03, 2023), tuid(leocesario, ["miren", "este", "lechoncito"])).
paraAprobar(fecha(25, 01, 2024), tuid(coirotomas, ["cumpli", "30", "me", "duele", "la", "espalda"])).
paraAprobar(fecha(17, 11, 2024), retuid(leocesario,  tuid(coirotomas, ["es", "mi", "cumple", "arrodíllense"]))).
paraAprobar(fecha(23, 06, 2024), tuid(bornoPot, ["gatito", "enBio", "clickea", "el", "link"])).


/* Punto 1 */

publicacionDe(Usuario, Contenido):-
    publicacion(_, tuid(Usuario, Contenido)).

publicacionDe(Usuario, Contenido):-
    publicacion(_, retuid(Usuario, tuid(_, Contenido))).


/* Punto 2 */

% a)
contieneFrase(Palabra1, Palabra2, Post):-
    contenido(Post, Contenido),
    nth1(Posicion1, Contenido, Palabra1),
    Posicion2 is Posicion1 + 1,
    nth1(Posicion2, Contenido, Palabra2).

contenido(tuid(_, Contenido), Contenido).
contenido(retuid(_, tuid(_, Contenido)), Contenido).

% b)
esDeBot(Post):-
    contieneFrase("gatito", "enBio", Post).

esDeBot(Post):-
    anioTuid(Post, Anio),
    Anio \= 2024.

esDeBot(Post):-
    anioRetuid(Post, Anio),
    Anio < 2015.

anioTuid(Post, Anio):-
    publicacion(fecha(_,_,Anio), Post).

anioTuid(Post, Anio):-
    paraAprobar(fecha(_,_,Anio), Post).

anioRetuid(retuid(_, Post), Anio):-
    anioTuid(Post, Anio).


/* Punto 3 */

verdaderoAutor(Autor, Post):-
    autor(Post, Autor).

autor(tuid(Autor, _), Autor).
autor(retuid(_, tuid(Autor, _)), Autor).


/* Punto 4 */

postsParaPublicar(Autor, PostsEnProceso):-
    forall(member(Post, PostsEnProceso), not(esDeBot(Post))), % verifica que no son de bot
    enProceso(PostsEnProceso, Autor).

enProceso([], _).

enProceso([Post | Posts], Autor):-
    paraAprobar(_, Post),
    autor(Post, Autor),
    enProceso(Posts, Autor).


/* Punto 5 */

favorecido(Usuario):-
    usuario(Usuario),
    not(publicacion(_, retuid(Usuario, _))),
    forall(publico(Usuario, Post), not(contieneFrase("cryptos", "gratis", Post))).

usuario(Usuario):- distinct(Usuario, publicacion(_, tuid(Usuario, _))).
usuario(leocesario).

publico(Usuario, Post):-
    publicacion(_, Post),
    verdaderoAutor(Usuario, Post).

publico(Usuario, Post):-
    paraAprobar(_, Post),
    verdaderoAutor(Usuario, Post).


/* Punto 6 */

esteEsWallE(Usuario):-
    usuario(Usuario),
    forall(publico(Usuario, Post), esDeBot(Post)).

esteEsWallE(Usuario):-
    fecha(Fecha),
    coincideFechas(Usuario, Fecha).

coincideFechas(Usuario, Fecha):-
    usuario(Usuario),
    findall(PostRaro, (publicacion(Fecha, PostRaro), publico(Usuario, PostRaro)), PostsRaros),
    length(PostsRaros, CantRaros),
    CantRaros > 5.

fecha(Fecha):- distinct(Fecha, publicacion(Fecha, _)).


/* Punto 7 */

elMejorTimeline(Cantidad, Posts):-
    forall(member(Post, Posts), (publico(Usuario, Post), favorecido(Usuario))),
    Posts =< Cantidad.

elMejorTimeline(Cantidad, Posts):-
    forall(member(Post, Posts), (publico(melonTusk, Post), verdaderoAutor(melonTusk, Post))),
    Posts =< Cantidad.

elMejorTimeline(Cantidad, Posts):-
    usuario(Usuario),
    forall(member(Post, Posts), (contieneFrase("paga", "Tuiderr", Post), publico(Usuario, Post))),
    Posts =< Cantidad.
    

/* 
canieriasLegales(Piezas, Canieria):-
    subconjunto(Piezas, Canieria),
    canieriaBienArmada(Canieria).

subconjunto(_,[]).

subconjunto(Conjunto, [Elemento | OtrosElementos]):-
    select(Elemento, Conjunto, RestoConjunto),
    subconjunto(RestoConjunto, OtrosElementos).

 */

    
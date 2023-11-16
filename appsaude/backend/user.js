const express = require('express');
const router = express.Router();
var db = require('./db.js');

router.route('/register').post((req, res) => {
    //get params
    var cpf = req.body.cpf;
    var cargo = req.body.cargo;
    var email = req.body.email;
    var senha = req.body.senha;

    var sql = "SELECT * FROM user WHERE email=? OR cpf = ?";
    db.query(sql, [email, cpf], function (err, data, fields) {
        if (data.length > 0) {
            res.send(JSON.stringify({ success: false, message: err }));
        } else {
            //create query
            var sqlQuery = "INSERT INTO user (`cpf`, `email`, `senha`, `cargo`) VALUES (?,?,?,?)";

            //call database to insert so add or include database 
            // ???? pass params here

            db.query(sqlQuery, [cpf, email, senha, cargo], function (error, data, fields) {

                if (error) {
                    // if error send response here
                    res.send(JSON.stringify({ success: false, message: error }));
                } else {
                    // if success send response here
                    res.send(JSON.stringify({ success: true, message: 'register' }));
                }
            });
        }
    });
});


router.route('/login').post((req, res) => {

    var email = req.body.email;
    var senha = req.body.senha;

    var sql = "SELECT * FROM user WHERE email=? AND senha=?";

    if (email != "" && senha != "") {
        db.query(sql, [email, senha], function (err, data, fields) {
            if (err) {
                res.send(JSON.stringify({ success: false, message: err }));

            } else {
                if (data.length > 0) {
                    res.send(JSON.stringify({ success: true, user: data }));
                } else {
                    res.send(JSON.stringify({ success: false, message: 'Empty Data' }));
                }
            }
        });
    } else {
        res.send(JSON.stringify({ success: false, message: 'Email and password required!' }));
    }

});

router.route('/medico').post((req, res) => {

    var sql = "SELECT * FROM prontuarios ORDER BY status ASC";

        db.query(sql, [], function (err, data, fields) {
            if (err) {
                res.send(JSON.stringify({ success: false, message: err }));

            } else {
                if (data.length > 0) {
                    res.send(JSON.stringify({ success: true, prontuario: data}));
                } else {
                    res.send(JSON.stringify({ success: false, message: 'Empty Data' }));
                }
            }
        });
    

});

router.route('/createReceita').post((req, res) => {

    var remedio = req.body.remedio;
    var quantidade = req.body.quantidade;
    var cpf = req.body.cpf;


    var sql = "UPDATE prontuarios SET receita = ?, quantidadeRemedio = ?, boolRemedio = '0', status = 'fechado' WHERE (cpf = ?)";

        db.query(sql, [remedio, quantidade, cpf], function (err, data, fields) {
            if (err) {
                
                res.send(JSON.stringify({ success: false, message: err }));

            } else {
               
                    res.send(JSON.stringify({ success: true }));
               
            }
        });
});

router.route('/createProntuario').post((req, res) => {

    var nome = req.body.nome;
    var observacao = req.body.observacao;
    var pressao = req.body.pressao;
    var cpf = req.body.cpf;
    var peso = req.body.peso;
    var idade = req.body.idade;
    
    var sql1 = "SELECT * FROM user WHERE cpf = ?";
    db.query(sql1, [cpf], function (err, data, fields) {
        if (err) {
            
            res.send(JSON.stringify({ success: false, message: err }));

        } else {
           
            if (data.length > 0) {
                var sql = "INSERT INTO `prontuarios` (`cpf`, `nome`, `idade`, `peso`, `pressao`, `observacoes`, `receita`, `quantidadeRemedio`, `boolRemedio`, `status`, `horario`) VALUES (?, ?, ?, ?, ?, ?, 'Receita não disponibilizada', '0', '0', 'aberto', NOW());";

        db.query(sql, [cpf, nome, idade, peso, pressao, observacao], function (err, data, fields) {
            if (err) {
                
                res.send(JSON.stringify({ success: false, message: err }));

            } else {
               
                    res.send(JSON.stringify({ success: true }));
               
            }
        });
            } else {
                res.send(JSON.stringify({ success: false, message: "Este CPF não está cadastrado !" }));
            }

           
        }
    });

    
});

router.route('/paciente').post((req, res) => {

    var cpf = req.body.cpf;

    var sql = "SELECT * FROM prontuarios WHERE cpf = ?";

        db.query(sql, [cpf], function (err, data, fields) {
            if (err) {
                res.send(JSON.stringify({ success: false, message: err }));

            } else {
                if (data.length > 0) {
                    res.send(JSON.stringify({ success: true, prontuario: data}));
                } else {
                    res.send(JSON.stringify({ success: false, message: 'Empty Data' }));
                }
            }
        });
    

});

router.route('/farmacia').post((req, res) => {

    

    var sql = "SELECT cpf, receita, quantidadeRemedio, boolRemedio FROM prontuarios";

        db.query(sql, [], function (err, data, fields) {
            if (err) {
                res.send(JSON.stringify({ success: false, message: err }));

            } else {
                if (data.length > 0) {


                    res.send(JSON.stringify({ success: true, receitas: data}));


                } else {
                    res.send(JSON.stringify({ success: false, message: 'Empty Data' }));
                }
            }
        });
    

});

router.route('/controle').post((req, res) => {

    var receita = req.body.receita;
    var quantidade = req.body.quantidade;
    var boolRemedio = req.body.boolRemedio;
    var cpf = req.body.cpf;

    var sql = "UPDATE `remedios` SET `quantidade` = `quantidade` - ? WHERE (`nomeRemedio` = ?)";
    var sql1 = "UPDATE `prontuarios` SET `boolRemedio` = '1' WHERE (`cpf` = ?);";

        db.query(sql, [quantidade, receita], function (err, data, fields) {
            if (err) {
                res.send(JSON.stringify({ success: false, message: err }));

            } else {

                db.query(sql1, [cpf], function (err, data, fields) {
                    if (err) {

                        res.send(JSON.stringify({ success: false, message: err }));
        
                    } else {
                        res.send(JSON.stringify({ success: true}));
                    }
                });
            }
        });
    

});

router.route('/estoque').post((req, res) => {

    

    var sql = "SELECT * FROM remedios";

        db.query(sql, [], function (err, data, fields) {
            if (err) {
                res.send(JSON.stringify({ success: false, message: err }));

            } else {
                if (data.length > 0) {


                    res.send(JSON.stringify({ success: true, receitas: data}));


                } else {
                    res.send(JSON.stringify({ success: false, message: 'Empty Data' }));
                }
            }
        });
    

});

module.exports = router;
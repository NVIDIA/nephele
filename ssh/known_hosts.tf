%{~ if try(login, "") != "" ~}
${login} ${file(pubkey_host)}
%{~ endif ~}

%{~ if try(x4v100, "") != "" ~}
${x4v100} ${file(pubkey_host)}
%{~ endif ~}

%{~ if try(x8v100, "") != "" ~}
${x8v100} ${file(pubkey_host)}
%{~ endif ~}

%{~ if try(x8a100_40g, "") != "" ~}
${x8a100_40g} ${file(pubkey_host)}
%{~ endif ~}

%{~ if try(x8a100_80g, "") != "" ~}
${x8a100_80g} ${file(pubkey_host)}
%{~ endif ~}

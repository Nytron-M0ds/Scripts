#!/usr/bin/env python3
"""
NYTRON Lua Obfuscator
Ofusca scripts Lua para loadstring
"""

import random
import string
import base64

def string_to_bytes(s):
    """Converte string para sequência de bytes Lua"""
    return '\\' + '\\'.join(str(ord(c)) for c in s)

def obfuscate_simple(code):
    """Ofuscação simples com bytes"""
    return f'loadstring("{string_to_bytes(code)}")()'

def obfuscate_base64(code):
    """Ofuscação com base64"""
    encoded = base64.b64encode(code.encode()).decode()
    
    decoder = f'''
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end
loadstring(dec("{encoded}"))()
'''
    return decoder

def obfuscate_hex(code):
    """Ofuscação com hexadecimal"""
    hex_code = code.encode().hex()
    
    decoder = f'''
local h="{hex_code}"
local s=""
for i=1,#h,2 do
    s=s..string.char(tonumber(h:sub(i,i+1),16))
end
loadstring(s)()
'''
    return decoder

def obfuscate_advanced(code):
    """Ofuscação avançada com múltiplas camadas"""
    # Primeira camada: converter para bytes
    bytes_array = [str(ord(c)) for c in code]
    bytes_str = ','.join(bytes_array)
    
    # Gerar nomes aleatórios
    var1 = ''.join(random.choices(string.ascii_lowercase, k=8))
    var2 = ''.join(random.choices(string.ascii_lowercase, k=8))
    var3 = ''.join(random.choices(string.ascii_lowercase, k=8))
    
    decoder = f'''
local {var1}={{
{bytes_str}
}}
local {var2}=""
for {var3}=1,#{var1} do
{var2}={var2}..string.char({var1}[{var3}])
end
loadstring({var2})()
'''
    return decoder

def main():
    # Ler o script original
    with open('/home/ubuntu/NYTRON_StealBrainrot/StealBrainrot_NYTRON.lua', 'r') as f:
        original_code = f.read()
    
    print("Ofuscando script...")
    
    # Gerar versão ofuscada avançada
    obfuscated = obfuscate_advanced(original_code)
    
    # Salvar versão ofuscada
    with open('/home/ubuntu/NYTRON_StealBrainrot/StealBrainrot_OBFUSCATED.lua', 'w') as f:
        f.write(obfuscated)
    
    # Gerar versão hex (mais compacta)
    hex_version = obfuscate_hex(original_code)
    with open('/home/ubuntu/NYTRON_StealBrainrot/StealBrainrot_HEX.lua', 'w') as f:
        f.write(hex_version)
    
    print("Ofuscação concluída!")
    print("Arquivos gerados:")
    print("- StealBrainrot_OBFUSCATED.lua (bytes array)")
    print("- StealBrainrot_HEX.lua (hexadecimal)")

if __name__ == "__main__":
    main()

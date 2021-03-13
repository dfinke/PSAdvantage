# function New-GHSecret {
#     <#
#         .Synopsis
#         Creates a repository secret with an encrypted value

#         .Example
#     #>

#     # var secretValue = System.Text.Encoding.UTF8.GetBytes("mySecret");
#     # var publicKey = Convert.FromBase64String("2Sg8iYjAxxmI2LvUXpJjkYrMxURPc8r+dB7TJyvvcCU=");
#     # var sealedPublicKeyBox = Sodium.SealedPublicKeyBox.Create(secretValue, publicKey);
    
    
#     # Console.WriteLine(Convert.ToBase64String(sealedPublicKeyBox));    
# }
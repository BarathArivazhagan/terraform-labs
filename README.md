### Terraform Scripts

Some useful terraform scripts to create, plan, change and destroy infrastructure


#### Compatability Matrix

choose the branch based on below maintained versions.

<table>
 <tr>
    <th style="text-align:left">Branch</th>
    <th style="text-align:left">Terraform</th>
  </tr>
  <tr>
    <td>master</td>
    <td>0.12</td>
  </tr>  
  <tr>
    <td>0.11.x</td>  
    <td>0.11</td>
  </tr>  
</table>


##### Setup terraform in linux (0.12.4)

```sh
wget https://releases.hashicorp.com/terraform/0.12.4/terraform_0.12.4_linux_amd64.zip
unzip terraform_0.12.4_linux_amd64.zip 
mv terraform /usr/local/bin/
export PATH=$PATH:/usr/local/bin
```
